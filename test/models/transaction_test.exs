defmodule BeanApp.TransactionTest do
  use ExUnit.Case, async: false
  doctest BeanApp.Transaction

  alias BeanApp.Transaction
  alias Workers.Classifier

  import Mock

  setup do
    description = "foo, bar and baz"
    Transaction.create_index
    Transaction.save ({description, "some_merchant"})
    Transaction.refresh_index

    on_exit fn -> Transaction.delete_index end

    [description: description]
  end


  test "find by description", context do
    [transaction] = Transaction.find("foo")
    assert transaction.description == context[:description]

    [transaction] = Transaction.find("baz")
    assert transaction.description == context[:description]
  end

  test "find by merchant", context do
    [transaction] = Transaction.find_by_merchant_name("some_merchant")
    assert transaction.description == context[:description]
  end

  test "reindex_unknowns" do
    Transaction.save ({"foo", Classifier.unknown})
    Transaction.refresh_index

    with_mock BeanApp.Loader, [queue_transaction: fn("foo") -> :ok end] do
      assert Transaction.reindex_unknowns == [:ok]
    end
  end
end
