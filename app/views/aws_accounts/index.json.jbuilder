json.array!(@aws_accounts) do |aws_account|
  json.extract! aws_account, :id, :account_id, :name, :access_key, :secret_key
  json.url aws_account_url(aws_account, format: :json)
end
