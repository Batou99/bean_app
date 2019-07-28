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

  defstruct id: nil, description: [], merchant_name: []

  def create_index do
    Elastic.Index.create("#{@es_index}/#{@es_type}", @index_params)
  end

  def delete_index do
    Elastic.Index.delete(@es_index)
  end

  def refresh_index do
    Elastic.Index.refresh(@es_index)
  end

  def write({description, merchant_name}) do
    index(hash(description), %{description: description, merchant_name: merchant_name})
  end

  def reindex_unknowns do
    find_by_merchant_name("unknown")
    |> Enum.map(&(&1.description))
    |> Enum.map(&BeanApp.Loader.queue_transaction/1)
  end

  def find(text) do
    search(%{query: %{match: %{description: text}}})
  end

  def find_by_merchant_name(text) do
    search(%{query: %{match: %{merchant_name: text}}})
  end

  defp hash(id) do
    :crypto.hash(:sha, id) |> Base.encode16
  end
end
