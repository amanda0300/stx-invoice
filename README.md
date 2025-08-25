# STX Invoice Payment System

A simple and secure smart contract for managing STX invoice payments on the Stacks blockchain.

## Features

- Create invoices with specified amounts for customers
- Process STX payments for invoices
- Withdraw collected payments (admin only)
- View invoice details and total invoice count
- Secure authorization checks
- Event logging for tracking activities

## Contract Functions

### Administrative Functions

```clarity
(create-invoice (customer principal) (amount uint))
```
Creates a new invoice for a specified customer with the given amount. Only contract administrator can create invoices.

```clarity
(withdraw-stx (amount uint))
```
Withdraws STX from the contract. Only contract administrator can withdraw funds.

### Public Functions

```clarity
(pay-invoice (id uint))
```
Allows customers to pay their invoices using STX.

### Read-Only Functions

```clarity
(get-invoice (id uint))
```
Returns invoice details for a given invoice ID.

```clarity
(get-invoice-count)
```
Returns the total number of invoices created.

## Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet)
- Node.js and NPM
- [Stacks Wallet](https://www.hiro.so/wallet)

### Installation

1. Clone the repository
2. Install dependencies:
```bash
npm install
```

### Testing

Run the test suite:
```bash
clarinet test
```

## Security

- All functions include proper authorization checks
- Data validation for all inputs
- Safe STX transfer handling
- Event logging for monitoring
