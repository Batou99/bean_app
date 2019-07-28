defmodule Workers.ClassifierTest do
  use ExUnit.Case, async: false
  doctest Workers.Classifier

  alias BeanApp.{Merchant, Transaction}
  alias Workers.Classifier

  import Mock

  test "classify unknown merchant" do
    with_mocks([
      {Merchant, [],[find:  fn("foo") -> [] end]},
      {Transaction, [], [write: fn({"foo", Classifier.unknown}) -> :ok end]},
      {IO, [], [puts: fn(_) -> :ok end]}
    ]) do
      assert Classifier.classify("foo") == :ok
    end
  end

  test "classify known merchant" do
    with_mocks([
      {Merchant, [],[find:  fn("foo") -> [%{name: "bar"}] end]},
      {Transaction, [], [write: fn({"foo", "bar"}) -> :ok end]},
      {IO, [], [puts: fn(_) -> :ok end]}
    ]) do
      assert Classifier.classify("foo") == :ok
    end
  end
end
