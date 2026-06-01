return {
  s("par", fmt(
    '(partial {})/(partial {})',
      { i(1), i(2, "x") }
  )),
  s("dif", fmt(
    '(d {})/(d {})',
      { i(1), i(2, "x") }
  )),
}
