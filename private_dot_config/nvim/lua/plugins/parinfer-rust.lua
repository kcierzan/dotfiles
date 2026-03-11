return {
  "eraserhd/parinfer-rust",
  build = "cargo build --release",
  ft = { "clojure", "scheme", "lisp", "fennel", "janet", "racket" },
  config = function()
    vim.g.parinfer_mode = "smart"
  end,
}
