defmodule BankServer do
    use GenServer
    import Logger

    def start_link(_) do
        GenServer.start_link(__MODULE__, %UserData{}, name: __MODULE__)
    end

    #serverAPI

    def init(user_data) do
        {:ok, user_data}
    end

    def handle_call({:show_money}, _from, user_data) do
        {:reply, user_data.amount, user_data}
    end

    def handle_cast(_, %UserData{blocked?: true} = user_data) do
        Logger.info(inspect user_data)
        {:noreply, user_data}
    end

    def handle_cast({:change, change}, user_data) do
        
        {:noreply, %{user_data | amount: user_data.amount + change}}
    end

    def handle_info({:blocked, is_blocked?}, user_data) do
        {:noreply, %{user_data | blocked?: is_blocked?}}
    end

    #clientAPI

    def show_money(server) do
        GenServer.call(server, {:show_money})
    end

    def deposit(server, amount) do
        GenServer.cast(server, {:change, amount})
    end

    def withdraw(server, amount) do
        GenServer.cast(server, {:change, -amount})
    end
    
    def block_account(server) do
        send(server, {:blocked, true})
    end

    def unblock_account(server) do
        send(server, {:blocked, false})
    end
end