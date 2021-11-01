# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
alias Teller.{AccountBalance, AccountDetails, Accounts, Transactions}
alias Teller.Repo
alias Teller.Schema.{Enrollment, Institution, CounterParty}

institution1 = %Institution{} |> Institution.changeset(%{name: "Chase"}) |> Repo.insert!()

institution2 =
  %Institution{} |> Institution.changeset(%{name: "Bank of America"}) |> Repo.insert!()

institution3 = %Institution{} |> Institution.changeset(%{name: "Wells Fargo"}) |> Repo.insert!()

enrollment1 =
  %Enrollment{}
  |> Enrollment.changeset(%{name: "Enrollemt1", username: "enrl01", password: "test01234"})
  |> Repo.insert!()

enrollment2 =
  %Enrollment{}
  |> Enrollment.changeset(%{name: "Enrollemt2", username: "enrl02", password: "test01234"})
  |> Repo.insert!()

enrollment3 =
  %Enrollment{}
  |> Enrollment.changeset(%{name: "Enrollemt3", username: "enrl03", password: "test01234"})
  |> Repo.insert!()

{:ok, account1} =
  Accounts.create(%{
    name: "Test account1",
    type: "depository",
    subtype: "checking",
    currency: "USD",
    last_four: "1234",
    enrollment_id: enrollment1.id,
    institution_id: institution1.id
  })

{:ok, account2} =
  Accounts.create(%{
    name: "Test account2",
    type: "savings",
    subtype: "checking",
    currency: "INR",
    last_four: "2345",
    enrollment_id: enrollment2.id,
    institution_id: institution2.id
  })

{:ok, account3} =
  Accounts.create(%{
    name: "Test account3",
    type: "current",
    subtype: "checking",
    currency: "EUR",
    last_four: "3456",
    enrollment_id: enrollment3.id,
    institution_id: institution2.id
  })

{:ok, account_details1} =
  AccountDetails.create(%{account_id: account1.id, account_number: "1234567890", ach: "123456789"})

{:ok, account_details2} =
  AccountDetails.create(%{account_id: account2.id, account_number: "12340987456", wire: "AWX234T"})

{:ok, account_details3} =
  AccountDetails.create(%{account_id: account3.id, account_number: "0123876549", ach: "702878271"})

{:ok, account_balance1} =
  AccountBalance.create(%{account_id: account1.id, ledger: "76708.33", available: "76517.39"})

{:ok, account_balance2} =
  AccountBalance.create(%{account_id: account2.id, ledger: "82333.52", available: "80151.46"})

{:ok, account_balance3} =
  AccountBalance.create(%{account_id: account3.id, ledger: "55555.23", available: "53254.55"})

{:ok, transaction01} =
  Transactions.create(%{
    account_id: account1.id,
    amount: "500",
    description: "ATM Withdrawal",
    date: DateTime.utc_now(),
    category: "services",
    processing_status: "complete",
    running_balance: "2000",
    status: "pending",
    type: "atm"
  })

{:ok, transaction02} =
  Transactions.create(%{
    account_id: account2.id,
    amount: "200",
    description: "Resonance Education",
    date: DateTime.utc_now(),
    category: "education",
    processing_status: "complete",
    running_balance: "1800",
    status: "pending",
    type: "wire"
  })

{:ok, transaction03} =
  Transactions.create(%{
    account_id: account2.id,
    amount: "150",
    description: "In-N-Out Burger",
    date: DateTime.utc_now(),
    category: "dining",
    processing_status: "complete",
    running_balance: "1650",
    status: "posted",
    type: "ach"
  })

counter_party1 =
  %CounterParty{}
  |> CounterParty.changeset(%{
    name: "CARDTRONICS",
    type: "organization",
    transaction_id: transaction01.id
  })
  |> Repo.insert!()

counter_party2 =
  %CounterParty{}
  |> CounterParty.changeset(%{
    name: "Resonance Education",
    type: "organization",
    transaction_id: transaction02.id
  })
  |> Repo.insert!()

counter_party3 =
  %CounterParty{}
  |> CounterParty.changeset(%{
    name: "In-N-Out Burger",
    type: "organization",
    transaction_id: transaction03.id
  })
  |> Repo.insert!()
