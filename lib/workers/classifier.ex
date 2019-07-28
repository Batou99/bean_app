defmodule Workers.Classifier do
  @behaviour Honeydew.Worker

  @unknown "Unknown"

  alias BeanApp.{Merchant, Transaction}

  def classify(description) do
    merchant = Merchant.find(description) |> List.first || %{name: @unknown}

    IO.puts description <> ", " <> merchant_string(merchant.name)

    Transaction.save ({description, merchant.name})
  end

  def unknown do
    @unknown
  end

  defp merchant_string(@unknown) do
    IO.ANSI.green <> "merchant: " <> IO.ANSI.red() <> @unknown <> IO.ANSI.reset()
  end

  defp merchant_string(name) do
    IO.ANSI.green <> "merchant: " <> name <> IO.ANSI.reset()
  end
end

