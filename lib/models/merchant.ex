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

  alias BeanApp.Merchant

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t
  }

  defstruct id: nil, name: []

  @spec create_index :: {:error, char(), any} | {:ok, any, any}
  def create_index do
    Elastic.Index.create("#{@es_index}/#{@es_type}", @index_params)
  end

  @spec delete_index :: {:error, char(), any} | {:ok, any, any}
  def delete_index do
    Elastic.Index.delete("#{@es_index}/#{@es_type}")
  end

  @spec refresh_index :: {:error, char(), any} | {:ok, any, any}
  def refresh_index do
    Elastic.Index.refresh(@es_index)
  end

  @spec save(String.t) :: {:error, char(), any} | {:ok, any, any}
  def save(name) do
    index(hash(name), %{name: name})
  end

  @spec find(String.t) :: [__MODULE__.t]
  def find(text) do
    search(%{query: %{match: %{name: text}}})
  end

  @spec hash(String.t) :: String.t
  defp hash(id) do
    :crypto.hash(:sha, id) |> Base.encode16
  end
end
