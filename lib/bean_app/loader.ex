defmodule BeanApp.Loader do
  alias BeanApp.Merchant

  def load_merchants do
    File.stream!("data/merchants.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Merchant.save /1)
  end

  def load_transactions do
    File.stream!("data/transactions.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&queue_transaction/1)
  end

  def queue_transaction(description) do
    {:classify, [description]} |> Honeydew.async(:transactions)
  end
end

