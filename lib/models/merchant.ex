defmodule BeanApp.Merchant do
  @es_type "merchant"
  @es_index "merchant"
  @index_params %{
    mappings: %{
      merchant: %{
        properties: %{
          name: %{analyzer: "english", type: "text"}
        }
      }
    }
  }

  use Elastic.Document.API

  defstruct id: nil, name: []

  def create_index do
    Elastic.Index.create("#{@es_index}/#{@es_type}", @index_params)
  end

  def delete_index do
    Elastic.Index.delete("#{@es_index}/#{@es_type}")
  end

  def refresh_index do
    Elastic.Index.refresh(@es_index)
  end

  def write(name) do
    index(hash(name), %{name: name})
  end

  def find(text) do
    search(%{query: %{match: %{name: text}}})
  end

  defp hash(id) do
    :crypto.hash(:sha, id) |> Base.encode16
  end
end
