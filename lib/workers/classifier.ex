defmodule Workers.Classifier do
  @behaviour Honeydew.Worker

  alias BeanApp.{Merchant, Transaction}

  def classify(description) do
    merchant = Merchant.find(description) |> List.first || %{name: "Unknown"}

    IO.puts description <> ", " <> merchant_string(merchant.name)

    Transaction.write({description, merchant.name})
  end

  defp merchant_string("Unknown") do
    IO.ANSI.green <> "merchant: " <> IO.ANSI.red() <> "Unknown" <> IO.ANSI.reset()
  end

  defp merchant_string(name) do
    IO.ANSI.green <> "merchant: " <> name <> IO.ANSI.reset()
  end
end

