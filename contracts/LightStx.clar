;; contracts/lightstx.clar
;; LightStx - Proof of Support 
;; A minimal contract where users send STX as a show of support.

(define-data-var owner principal tx-sender)
(define-data-var total uint u0)

(define-map supporters
  principal
  uint
)

;;  Send support (STX goes directly to contract owner)
(define-public (support (amount uint))
  (begin
    (as-contract (stx-transfer? amount tx-sender (var-get owner)))
    (let ((prev (default-to u0 (map-get? supporters tx-sender))))
      (map-set supporters tx-sender (+ prev amount))
      (var-set total (+ (var-get total) amount))
      (ok amount)
    )
  )
)

;; --- Views ---
(define-read-only (get-total) (var-get total))
(define-read-only (get-support (who principal)) (map-get? supporters who))
(define-read-only (get-owner) (var-get owner))
