# Transaction-fetcher

Fetches transactions and balance from an account and returns them in a structured format.

## Usage

```bash
docker run -e BANK=123123 -e USERID=123123 -e CUSTOMERID=123123 -e ACCOUNT_ID=123123 --entrypoint /bin/bash -it transaction-fetcher --fromdate=$FROM_DATE --todate=$TO_DATE
```
