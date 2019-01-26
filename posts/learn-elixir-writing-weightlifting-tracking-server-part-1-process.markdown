---
title: Learn Elixir - Writing a weightlifting tracking server - part 1 - processes
date: 2017-08-08
disqus: True
---

## Intro
Process to Elixir is like object to Object-oriented programming language. They are the fundamental units of actor concurrency model in Elixir/Erlang. Thanks to Erlang VM, they are much lighter weight than actual OS process and usually take few kb and microseconds and less than 2kb memory to create one.

In order to learn the concurrency model, I will start writing a toy project, a weightlifting tracking server.

## The App Server
We'll be developing an application server for keep tracking on the workout people done in the gym. We will start building the most naive version by using the most basic pieces, processes.

## Stateful server processes
Long running process that respond to various messages. It keep internal state by recursion.

## Project Setup
Repo is [here](https://github.com/bruteforcecat/strong-as-fuck). To see the source code:

```
git clone git@github.com:bruteforcecat/strong-as-fuck.git
cd strong-as-fuck
git checkout v0.0.1
```

## Stateful Server Process
We basically want to have a long running process that respond to different messages and it has to be stateful because it need to keep the training count.

```elixir
# lib/server.ex
defmodule StrongAsFuck.Server do

  alias StrongAsFuck.RecordBook, as: RecordBook

  def start() do
    spawn(&init/0)
  end

  def init() do
    loop get_initial_state()
  end

  defp loop(state) do
    new_state = receive do
      message ->
        handle_message(state, message)
    end
    loop(new_state)
  end
```

We will have a `start` function which will take a function and run it in a new process. In order to keep the process from exiting, we will use tail recursion. In `loop` function, we will wait to receive new message and obtain the new state after processing it and apply `loop` again with the new state.

## Message Passing
The concurrency model in Elixir/Erlang is called actor model. Actor is a process and they communicate exclusively by sending messages to another and there are no resources shared(which means the message is deeply-copied). Each process will have its own dedicated task.

In our `add_customer` function, we send a message by `send(server_pid, {:add_customer, gender, self() })`. The first argument id the pid(Process Id) returned by `start` function and second is the message content. Note that self is a function that return current process id. We will pass it as message content so the head count server can send response back to the caller process.

So in our application, we have a function `handle_message` to handle new message in mailbox. Note that `send caller, :ok` and `send caller, {:error, message}` is to send response back the caller process. The trick is to call `receive do response -> response end` in our interface function and this will block the caller process to wait until message is sent back to them.

```elixir
# lib/server.ex
def add_training_record(server_pid, movement) do
  send(server_pid, {:add_training_record, movement, self() })
  receive do
    response ->
      response
  end
end

defp handle_message(state, message) do
  case message do
    {:add_training_record, movement, caller} ->
      case RecordBook.add_record(state, movement) do
        {:ok, new_state} ->
          send caller, :ok
          new_state
        {:error, message} ->
          send caller, {:error, message}
          state
      end
    {:remove_training_record, movement, caller} ->
      case RecordBook.remove_record(state, movement) do
        {:ok, new_state} ->
          send caller, :ok
          new_state
        {:error, message} ->
          send caller, {:error, message}
          state
      end
    {:get_stat, caller} ->
      send caller, {:ok, RecordBook.get_stat(state)}
      state
    _ ->
      state
  end
end
```

### RecordBook Struct
We model our application state as a Struct. Struct is basically Map under the food but providing a strict data structure. One advantage is that if we try to access non-existing property on a struct, we will receive error in compile time.

```Elixir
# lib/record_book.ex
defmodule StrongAsFuck.RecordBook do

  @movements ~w(pullup pushup)a
  defstruct pullup: 0, pushup: 0

  def add_record(
    book,
    movement
  ) when movement in @movements do
    book
    |> Map.put(movement, Map.get(book, movement) + 1)
    |> validate
  end

  ....
```

## Play with it in Iex
```sh
iex -S mix
server_pid = StrongAsFuck.Server.start()
#PID<0.105.0>
StrongAsFuck.Server.add_training_record(
  server_pid, :pullup
)
# :ok
StrongAsFuck.Server.add_training_record(
  server_pid, :pushup
)
# :ok
StrongAsFuck.Server.add_training_record(
  server_pid, :pushup
)
# :ok
StrongAsFuck.Server.get_stat(server_pid)
{:ok, %{pullup: 1, pushup: 2}}
```

Now our extreme naive stateful head count server is complete. In the next part, we will improve it by using registering process with name instead of pid, error handling.
