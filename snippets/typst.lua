return {
  s("par", fmt(
    '(partial {})/(partial {})',
      { i(1), i(2, "x") }
  ))
}
