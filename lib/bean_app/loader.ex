defmodule BeanApp.Loader do
  alias BeanApp.Merchant

  @spec load_merchants :: [{:error, char(), any} | {:ok, any, any}]
  def load_merchants do
    load_file("date/merchants.txt")
    |> Enum.map(&Merchant.save /1)
  end

  @spec load_transactions :: [%Honeydew.Job{}]
  def load_transactions do
    load_file("date/transactions.txt")
    |> Enum.map(&queue_transaction/1)
  end

  @spec queue_transaction(String.t) :: %Honeydew.Job{}
  def queue_transaction(description) do
    {:classify, [description]} |> Honeydew.async(:transactions)
  end

  @spec load_file(Path.t) :: [String.t]
  defp load_file(name), do: File.stream!(name) |> Enum.map(&String.trim/1)
end

