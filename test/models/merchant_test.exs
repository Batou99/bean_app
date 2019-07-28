defmodule BeanApp.MerchantTest do
  use ExUnit.Case
  doctest BeanApp.Merchant

  alias BeanApp.Merchant

  setup do
    Merchant.create_index

    on_exit fn -> Merchant.delete_index end
  end

  test "write and find" do
    Merchant.write("Google")
    [merchant] = Merchant.find("google")

    assert merchant.name == "Google"
  end
end
