defmodule UserData do
    defstruct(
        user_id: nil,
        amount: 0,
        blocked?: false
    )
    @type t :: %UserData{user_id: integer, amount: number, blocked?: boolean }
end