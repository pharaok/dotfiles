local a = function(t)
  return {
    trig = t,
    wordTrig = false,
    snippetType = "autosnippet",
  }
end
local w = function(t, r)
  return s(
    {
      trig = t .. "(%s)",
      trigEngine = function(_)
        return function(line_to_cursor, trigger)
          local find_res = { line_to_cursor:find(trigger .. "$") }
          if #find_res > 0 then
            local captures = {}

            local from = find_res[1]

            -- negative look behind
            if from > 1 and line_to_cursor:sub(from - 1, from - 1) == "\\" then
              return nil
            end

            local match = line_to_cursor:sub(from)

            captures[1] = find_res[3]
            return match, captures
          else
            return nil
          end
        end
      end,
      snippetType = "autosnippet",
    },
    f(function(_, snip)
      return r .. snip.captures[1]
    end)
  )
end
local am = function(t) -- auto mathzone snippet trigger
  return {
    trig = t,
    wordTrig = false,
    snippetType = "autosnippet",
    condition = vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1,
  }
end
local set = function(set_symbol)
  return s(
    { trig = string.rep(set_symbol, 2) .. "([%+%-%*]?)([^%+%-%*])", regTrig = true, snippetType = "autosnippet" },
    f(function(_, snip)
      return "\\mathbb{"
          .. set_symbol
          .. "}"
          .. (snip.captures[1] ~= "" and ("^" .. snip.captures[1]) or "")
          .. snip.captures[2]
    end)
  )
end

local snippets = {
  s(
    "!!!",
    fmta(
      [[
        \documentclass[12pt]{article}

        \usepackage{amsmath}
        \usepackage{amssymb}

        \begin{document}
            <>
        \end{document}
      ]],
      { i(0) }
    )
  ),

  s(am("inv"), t("^{-1}")),
  s(am("sr"), t("^2")),
  s(am("cb"), t("^3")),
  s(am("pw"), fmta("^{<>}", { i(1) })),
  s(am("rt"), fmta("\\sqrt{<>}", i(1))),
  s({
    trig = "nrt",
    priority = 1100,
    wordTrig = false,
    snippetType = "autosnippet",
  }, fmta("\\sqrt[<>]{<>}", { i(1), i(2) })),

  s("fr", fmta("\\frac{<>}{<>}", { i(1), i(2) })),
  s(
    "en",
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      { i(1), i(2), rep(1) }
    )
  ),
  s(
    { trig = "(%d+)/(%d+)(%s)", regTrig = true, snippetType = "autosnippet" },
    f(function(_, snip)
      return ("\\frac{%s}{%s}%s"):format(unpack(snip.captures))
    end)
  ),
  s(
    { trig = "([%l%u])(%d)", regTrig = true, snippetType = "autosnippet" },
    f(function(_, snip)
      return ("%s_%s"):format(unpack(snip.captures))
    end)
  ),
  s(
    { trig = "([%l%u])hat", regTrig = true, snippetType = "autosnippet" },
    f(function(_, snip)
      return ("\\hat{%s}"):format(snip.captures[1])
    end)
  ),
  s("limx", fmta("\\lim\\limits_{x \\to <>}", i(1))),
  w("int", "\\int"),

  s("mi", fmta("$<>$", i(1))),
  s("mm", fmta("$$<>$$", i(1))),
  s(
    "mk",
    fmta(
      [[
        \[
            <>
        \]
      ]],
      i(1)
    )
  ),
  s(
    "eq",
    fmta(
      [[
        \begin{equation}
            <>
        \end{equation}
      ]],
      i(1)
    )
  ),

  s(
    "ol",
    fmta(
      [[
        \begin{enumerate}
            <>
        \end{enumerate}
      ]],
      i(1)
    )
  ),
  s(
    "ul",
    fmta(
      [[
        \begin{itemize}
            <>
        \end{itemize}
      ]],
      i(1)
    )
  ),
  s("li", t("\\item")),

  s("bi", fmta("\\binom{<>}{<>}", { i(1), i(2) })),

  s("lr", fmta("\\left( <> \\right)", i(1))),
  s("lr[", fmta("\\left[ <> \\right]", i(1))),

  -- sympy
  -- s(
  --   { trig = "ans", wordTrig = false },
  --   f(function(_, _)
  --     return vim.fn.getreg("9")
  --   end)
  -- ),
  -- s(
  --   { trig = "([xyz])=", regTrig = true, hidden = true },
  --   f(function(_, snip)
  --     local cur_r, cur_c = unpack(vim.api.nvim_win_get_cursor(0))
  --     local lines = vim.api.nvim_buf_get_text(0, 0, 0, cur_r, cur_c, {})
  --     local er, ec = 0, 0 -- 1 indexed
  --
  --     for r = #lines, 1, -1 do
  --       _, ec = lines[r]:find(".*(=)")
  --       if ec ~= nil then
  --         er = r
  --
  --         break
  --       end
  --     end
  --     print(er, ec)
  --
  --     local var = snip.captures[1]
  --     print(var)
  --     return ""
  --   end)
  -- ),

  -- Greek letters
  s(a(";a"), t("\\alpha")),
  s(a(";b"), t("\\beta")),
  s(a(";p"), t("\\pi")),
  s(a(";m"), t("\\mu")),
  s(a(";t"), t("\\tau")),
  s(a(";T"), t("\\theta")),
  s(a(";r"), t("\\rho")),
  s(a(";f"), t("\\phi")),
  s(a(";o"), t("\\omega")),

  -- Symbols
  s(am("!="), t("\\neq")),
  s(am("~~"), t("\\approx")),
  s(am("+-"), t("\\pm")),
  s(am("-+"), t("\\mp")),
  s(am("<="), t("\\leq")),
  s(am(">="), t("\\geq")),

  w("%.%.%.", "\\cdots"),
  w("%.", "\\cdot"),
  w("not", "\\not"),
  w("inf", "\\infty"),
  w("in", "\\in"),
  w("nin", "\\notin"),
  w("sub", "\\subset"),
  w("sup", "\\supset"),
  s({ trig = "uu", snippetType = "autosnippet" }, t("\\cup")),
  s({ trig = "nn", snippetType = "autosnippet" }, t("\\cap")),

  w("OO", "\\O"),
  set("N"),
  set("Z"),
  set("Q"),
  set("R"),

  -- Linear Algebra
  s({
      trig = "mat(%d)(%d)",
      regTrig = true,
      hidden = true,
    },
    fmta(
      [[
        \begin{bmatrix}
            <>
        \end{bmatrix}
      ]], {
        d(1, function(_, snip)
          local n = tonumber(snip.captures[1])
          local m = tonumber(snip.captures[2])
          local nodes = {}

          for r = 1, n do
            for c = 1, m do
              local k = (r - 1) * m + c
              table.insert(nodes, i(k))
              if c ~= m then table.insert(nodes, t(" & ")) end
            end
            if r ~= n then table.insert(nodes, t({ " \\\\", "    " })) end
          end

          return sn(nil, nodes)
        end)
      }
    )
  ),
}

-- Functions
for _, fn in ipairs({ "sin", "cos", "tan", "csc", "sec", "cot", "log", "ln", "min", "max", "gcd", "det" }) do
  table.insert(snippets, s({ trig = fn, wordTrig = true, snippetType = "autosnippet" }, t("\\" .. fn)))
end

return snippets
