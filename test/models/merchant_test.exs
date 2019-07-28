defmodule BeanApp.MerchantTest do
  use ExUnit.Case
  doctest BeanApp.Merchant

  alias BeanApp.Merchant

  setup do
    Merchant.create_index

    on_exit fn -> Merchant.delete_index end
  end

  test "save and find" do
    Merchant.save ("Google")
    [merchant] = Merchant.find("google")

    assert merchant.name == "Google"
  end
end
