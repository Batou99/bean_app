defmodule BeanApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias BeanApp.{Merchant, Transaction, Loader}
  alias Honeydew.Queue.Mnesia

  use Application

  def start(_type, _args) do
    prepare_indexes()
    create_queues()
    load_data()
    start_workers()

    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Honeydew.WorkerSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp prepare_indexes do
    Merchant.create_index
    Transaction.create_index
  end

  defp create_queues do
    :ok = Honeydew.start_queue(:transactions, queue: {Mnesia, [disc_copies: [node()]]})
  end

  defp start_workers do
    :ok = Honeydew.start_workers(:transactions, Workers.Classifier)
  end

  defp load_data do
    Loader.load_merchants
    Elastic.Index.refresh("merchant")
    Loader.load_transactions
  end
end
