defmodule Workers.Classifier do
  @behaviour Honeydew.Worker

  @unknown "Unknown"

  alias BeanApp.{Merchant, Transaction}

  @spec classify(String.t) :: {:error, char(), any} | {:ok, any, any}
  def classify(description) do
    merchant = Merchant.find(description) |> List.first || %{name: @unknown}

    IO.puts description <> ", " <> merchant_string(merchant.name)

    Transaction.save ({description, merchant.name})
  end

  @spec unknown :: String.t
  def unknown do
    @unknown
  end

  # NOTE: No spec because overloaded contracts are not supported
  defp merchant_string(@unknown) do
    IO.ANSI.green <> "merchant: " <> IO.ANSI.red() <> @unknown <> IO.ANSI.reset()
  end

  @spec merchant_string(String.t) :: String.t
  defp merchant_string(name) do
    IO.ANSI.green <> "merchant: " <> name <> IO.ANSI.reset()
  end
end

