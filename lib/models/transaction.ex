defmodule BeanApp.Transaction do
  @es_type "transaction"
  @es_index "transaction"
  @index_params %{
    mappings: %{
      properties: %{
        description: %{analyzer: "english", type: "text"},
        merchant_name: %{analyzer: "english", type: "text"}
      }
    }
  }

  use Elastic.Document.API

  alias Workers.Classifier
  alias BeanApp.Transaction

  @type t :: %__MODULE__{
    id: String.t,
    description: String.t,
    merchant_name: String.t
  }

  defstruct id: nil, description: [], merchant_name: []

  @spec create_index :: {:error, char(), any} | {:ok, any, any}
  def create_index do
    Elastic.Index.create("#{@es_index}/#{@es_type}", @index_params)
  end

  @spec delete_index :: {:error, char(), any} | {:ok, any, any}
  def delete_index do
    Elastic.Index.delete(@es_index)
  end

  @spec refresh_index :: {:error, char(), any} | {:ok, any, any}
  def refresh_index do
    Elastic.Index.refresh(@es_index)
  end

  @spec save({String.t, String.t}) :: {:error, char(), any} | {:ok, any, any}
  def save({description, merchant_name}) do
    index(hash(description), %{description: description, merchant_name: merchant_name})
  end

  @spec reindex_unknowns :: [%Honeydew.Job{}]
  def reindex_unknowns do
    find_by_merchant_name(Classifier.unknown)
    |> Enum.map(&(&1.description))
    |> Enum.map(&BeanApp.Loader.queue_transaction/1)
  end

  @spec find(String.t) :: [Transaction.t]
  def find(text) do
    search(%{query: %{match: %{description: text}}})
  end

  @spec find_by_merchant_name(String.t) :: [__MODULE__.t]
  def find_by_merchant_name(text) do
    search(%{query: %{match: %{merchant_name: text}}})
  end

  @spec hash(String.t) :: String.t
  defp hash(id) do
    :crypto.hash(:sha, id) |> Base.encode16
  end
end
