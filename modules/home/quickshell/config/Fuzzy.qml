pragma Singleton
import QtQuick
import Quickshell

// fzf-style fuzzy matching.
//   match("Firefox Web Browser", "ffwb") → { score, positions: [0, 2, 8, 12] }  or null
// Characters must appear in order; matches score higher when they are
// consecutive, start a word, or start the string, and lower across gaps.
Singleton {
    readonly property int scoreMatch: 16
    readonly property int bonusBoundary: 24
    readonly property int bonusConsecutive: 18
    readonly property int bonusFirst: 12
    readonly property int penaltyGap: 2

    function isBoundary(text, i) {
        if (i === 0) return true;
        const prev = text[i - 1];
        const cur = text[i];
        if (" -_./\\:()[]".includes(prev)) return true;
        return prev === prev.toLowerCase() && cur !== cur.toLowerCase(); // camelCase
    }

    // Greedy match starting at a given position of the first query char.
    function matchFrom(text, lower, q, start) {
        const positions = [start];
        let score = scoreMatch + (isBoundary(text, start) ? bonusBoundary : 0) + (start === 0 ? bonusFirst : 0);
        let ti = start + 1;
        for (let qi = 1; qi < q.length; qi++) {
            // Prefer the next boundary occurrence over a plain one if it isn't far away.
            let best = -1;
            for (let j = ti; j < lower.length; j++) {
                if (lower[j] !== q[qi]) continue;
                if (best < 0) best = j;
                if (j === ti || isBoundary(text, j)) { best = j; break; }
                if (j - best > 6) break;
            }
            if (best < 0) return null;
            const gap = best - ti;
            score += scoreMatch;
            if (gap === 0) score += bonusConsecutive;
            else score -= Math.min(gap, 10) * penaltyGap;
            if (isBoundary(text, best)) score += bonusBoundary;
            positions.push(best);
            ti = best + 1;
        }
        return { score, positions };
    }

    function match(text, query) {
        if (!text) return null;
        const q = query.toLowerCase().replace(/\s+/g, "");
        if (q === "") return { score: 0, positions: [] };
        const lower = text.toLowerCase();
        let best = null;
        for (let i = lower.indexOf(q[0]); i >= 0; i = lower.indexOf(q[0], i + 1)) {
            const m = matchFrom(text, lower, q, i);
            if (m && (!best || m.score > best.score)) best = m;
        }
        if (best) best.score -= Math.floor(text.length / 8); // slight preference for short names
        return best;
    }

    // Rich-text version of `text` with matched characters highlighted.
    function highlight(text, positions, color) {
        const esc = c => c === "&" ? "&amp;" : c === "<" ? "&lt;" : c === ">" ? "&gt;" : c;
        const set = new Set(positions);
        let out = "";
        for (let i = 0; i < text.length; i++) {
            const c = esc(text[i]);
            out += set.has(i) ? `<font color="${color}"><b>${c}</b></font>` : c;
        }
        return out;
    }
}
