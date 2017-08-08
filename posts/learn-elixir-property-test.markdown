---
title: Learn Elixir - Property Test
date: 2017-08-06
disqus: True
---

## Intro
Elixir is an emerging functional programming language which is very suitable for using it in writing distributed system(Whatsapp ,Wooga, Riak) because powerful Erlang VM and OTP framework.

As a Elixir beginner, I would like to start series of learning Elixir. So the first one is property testing.

### Property Testing
Tests allow us to state an expectation and verify that the result of our part of program is as we expected. Most of engineers must be familiar with unit testing. In unit testing, we test the smallest independent unit(usually function) of the application. However, unit testing cannot ensure that our test have met our requirement unless we have written a lot of edge cases.

```ruby
# spec/reverse_spec.rb
describe "reverse" do
  it 'return original if reverse twice with argument [1,2,3]' do
    expect(reverse()).to eq(2)
    expect(reverse(reverse([1,2,3]))).to eq([1,2,3])
  end

  it 'return original if reverse twice with argument [9, 2, 3, 1]' do
    expect(reverse()).to eq(2)
    expect(reverse(reverse([9,2,3,1]))).to eq([9,2,3,1])
  end
end

# We will probably stop here but do we cover enough relevant case?
```

In property testing, the idea is that the test framework will help us randomly generating different argument and run our test . This is particularly common in language having good type system and immutable data structure.

### Using Excheck
The repo is [here](https://github.com/SWTPAIN/learning_property_test) if you are interested in looking at the code.
```

```elixir
# add quixir to dpes dependencies
defp deps do
  [
    {:excheck, "~> 0.5", only: :test},
    {:triq, github: "triqng/triq", only: :test}
  ]
end
```

```sh
# install new dependencies
mix deps.get
```

```elixir
# test/learning_property_test.exs
defmodule LearningPropertyTestTest do
  use ExUnit.Case, async: false
  use ExCheck

  property "x + 1 is always greater than x" do
    for_all x in int(), do: x + 1 >= x
  end

  property "x * x is always greater than x" do
    for_all x in int(), do: x * x > x
  end

end
```

```sh
mix test

# LearningPropertyTestTest
#   * test x * x is always greater than x_property (8.3ms)
# ....................................................................................................
#   1) test x * x is always greater than x_property (LearningPropertyTestTest)
#      test/learning_property_test_test.exs:9
#      Expected truthy, got false
#      code: ExCheck.check(prop_x * x is always greater than x(), context[:iterations])
#      stacktrace:
#        test/learning_property_test_test.exs:9: (test)
#
#   * test x + 1 is always greater than x_property (2.3ms)
#
# Finished in 0.06 seconds
# 101 tests, 1 failure
```


The test framework will randomly generate 500 different integers to ensure this property is not broken.

For second test, ExCheck reports that the property failed. There is no counter example for the failing case. However the community is working on [it](https://github.com/parroty/excheck/issues/36)

Now let's consider a simple Morse encoding module. There are only two public function which are `&encode/1` and `&decode/1`. So if the letters are valid, it should return the same letters after encode and decode it. It is easy to write the test for it as follows:


```elixir
lib/morse_test.exs
defmodule MorseTest do
  use ExUnit.Case, async: false
  use ExCheck

  @valid_letters  Morse.letter_to_morse |> Map.keys
  @valid_morses  Morse.letter_to_morse |> Map.values


  property "encode and decode return the same string if string only contain valid letter" do
    for_all letters in list(elements(@valid_letters)) do
      sentence = letters |> Enum.join
      sentence |> Morse.encode() |> elem(1) |> Morse.decode() |> elem(1) == sentence
    end
  end

  property "decode and encode return the same morses if string only contain valid morses" do
    for_all morses in list(elements(@valid_morses)) do
      morses_sentence = morses |> Enum.join(" ")
      morses_sentence |> Morse.decode() |> elem(1) |> Morse.encode() |> elem(1) == morses_sentence
    end
  end

end
```

### Conclusion
The idea of property testing is to think clearly what property our function should hold and let the test framework to help us generate hundreds of test cases to cover edge cases as much as possible. Even though the property test framework in Elixir is still in very beginning stage, I do think it's good enough to get started with it in any nontrivial project.
