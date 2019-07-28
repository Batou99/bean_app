defmodule Workers.ClassifierTest do
  use ExUnit.Case, async: false
  doctest Workers.Classifier

  alias BeanApp.{Merchant, Transaction}
  alias Workers.Classifier

  import Mock

  describe "classify unknown merchant" do
    setup do
      [mocks: [
        {Merchant, [],[
          find: fn
            "foo" -> []
            "Unknown" -> [] 
          end,
          save: fn("Unknown") -> :ok end]},
        {Transaction, [], [save: fn({"foo", "Unknown"}) -> :ok end]},
        {IO, [], [puts: fn(_) -> :ok end]}]
      ]
    end

    test "classify a transaction", context do
      with_mocks(context[:mocks]) do
        Classifier.classify("foo")

        assert_called Transaction.save({"foo", "Unknown"})
      end
    end

    test "creates a new unknown merchant", context do
      with_mocks(context[:mocks]) do
        Classifier.classify("foo")

        assert_called Merchant.save(Classifier.unknown)
      end
    end
  end

  describe "known merchant" do
    setup do
      [mocks: [
        {Merchant, [],[find:  fn("foo") -> [%Merchant{name: "bar"}] end]},
        {Transaction, [], [save: fn({"foo", "bar"}) -> :ok end]},
        {IO, [], [puts: fn(_) -> :ok end]}]
      ]
    end

    test "classify a transaction", context do
      with_mocks(context[:mocks]) do
        Classifier.classify("foo")

        assert_called Transaction.save({"foo", "bar"})
      end
    end
  end
end
