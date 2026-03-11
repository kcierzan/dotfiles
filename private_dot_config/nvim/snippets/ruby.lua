local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local f = ls.function_node
local r = ls.restore_node

return {
  -- sig { params(arg: Type).returns() }
  s("sig", {
    t("sig { "),
    c(1, {
      sn(nil, { t("params("), i(1, "arg: Type"), t(").") }),
      t(""), -- no params
    }),
    c(2, {
      sn(nil, { t("returns("), i(1, "Type"), t(")") }),
      t("void"),
    }),
    t(" }"),
  }),
  -- sig do block
  s("sigdo", {
    t({ "sig do", "  " }),
    c(1, {
      sn(nil, { t({ "params(", "    " }), i(1, "arg: Type"), t({ "", "  )." }) }),
      t(""),
    }),
    c(2, {
      sn(nil, { t({ "returns(", "    " }), i(1, "Type"), t({ "", "  )" }) }),
      t("void"),
    }),
    t({ "", "end" }),
  }),
  -- def <something>
  --  <something>
  -- end
  -- s({ trig = "def", desc = "Instance method" }, {
  --   t("def "),
  --   i(1),
  --   t({ "", "  " }),
  --   i(2),
  --   t({ "", "end", "" }),
  -- }),
  -- def self.<something>
  --   <something>
  -- end
  s({ trig = "def", desc = "Any flavor of method" }, {
    c(1, {
      fmt([[
  def {}{} = {}
  {}
  ]], {
        c(1, { t(""), t("self.") }),
        r(2, "name", i(2)),
        r(3, "body", i(3)),
        i(0)
      }),

      fmt([[
  def {}{}
    {}
  end
  {}
  ]], {
        c(1, { t(""), t("self.") }),
        r(2, "name", i(2)),
        r(3, "body", i(3)),
        i(0)
      }),
    }),
  }),
  s({ trig = "pw", desc = "persist_with from ResourceModel::Model" },
  {
    t({ "persist_with do", "  " }),
    i(1),
    t("end"),
    i(0)
  }
  ),
  s({ trig = "typed", desc = "Sorbet typing pragma" }, {
    t("# typed: "),
    c(1, { t("strong"), t("strict"), t("true"), t("false")}),
    t({"", ""}),
    i(0)
    }
  ),
  s({ trig = "fro", desc = "Frozen string literal"}, {
    t("# frozen_string_literal: true"),
    t({"", ""})
  })
}
