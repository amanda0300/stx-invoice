;; stx-invoice.clar
;; A simple STX invoice payment system

;; stx-invoice.clar
;; A simple STX invoice payment system

;; Error codes
(define-constant err-unauthorized (err u1))
(define-constant err-already-paid (err u2))
(define-constant err-low-amount (err u3))
(define-constant err-transfer-failed (err u4))
(define-constant err-not-found (err u5))

;; Contract owner
(define-constant contract-owner tx-sender)

;; Data vars
(define-data-var next-invoice-id uint u0)

;; Maps
(define-map invoices uint 
  {customer: principal, amount: uint, paid: bool})

;; Public functions
(define-public (create-invoice (customer principal) (amount uint))
  (let 
    (
      (invoice-id (var-get next-invoice-id))
      (invoice-data {customer: customer, amount: amount, paid: false})
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (> amount u0) err-low-amount)
    (print {event: "create-invoice", id: invoice-id})
    (var-set next-invoice-id (+ invoice-id u1))
    (ok (map-set invoices invoice-id invoice-data))))

(define-public (pay-invoice (id uint))
  (let ((invoice (unwrap! (map-get? invoices id) err-not-found)))
    (asserts! (not (get paid invoice)) err-already-paid)
    (let ((to-pay (get amount invoice)))
      (asserts! (> to-pay u0) err-low-amount)
      (try! (stx-transfer? to-pay tx-sender contract-owner))
      (print {event: "pay-invoice", id: id})
      (ok (map-set invoices id 
           (merge invoice {paid: true}))))))

(define-public (withdraw-stx (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (> amount u0) err-low-amount)
    (print {event: "withdraw", amount: amount})
    (as-contract
      (try! (stx-transfer? amount tx-sender tx-sender)))
    (ok true)))

;; Read only functions
(define-read-only (get-invoice (id uint))
  (map-get? invoices id))

(define-read-only (get-invoice-count)
  (var-get next-invoice-id))
