;; contracts/savings-vault.clar
;; STX Savings Vault
;; - Users lock STX into personal savings vaults
;; - Vaults have a goal + unlock block height
;; - Users can withdraw only after unlock

(define-data-var vault-count uint u0)

(define-map vaults
    { id: uint }
    {
        owner: principal,
        goal: uint,
        balance: uint,
        unlock-block: uint,
    }
)

(define-constant ERR-NOT-OWNER u100)
(define-constant ERR-TOO-EARLY u101)
(define-constant ERR-NOT-ENOUGH u102)

;; Create a vault with goal + lock time (in blocks)
(define-public (create-vault
        (goal uint)
        (lock-blocks uint)
    )
    (let (
            (id (+ u1 (var-get vault-count)))
            (unlock (+ burn-block-height lock-blocks))
        )
        (begin
            (var-set vault-count id)
            (map-set vaults { id: id } {
                owner: tx-sender,
                goal: goal,
                balance: u0,
                unlock-block: unlock,
            })
            (ok id)
        )
    )
)

;; Deposit STX into vault
(define-public (deposit
        (id uint)
        (amount uint)
    )
    (let ((vault (map-get? vaults { id: id })))
        (begin
            (asserts! (is-some vault) (err ERR-NOT-ENOUGH))
            (as-contract (stx-transfer? amount tx-sender (contract-caller)))
            (let ((v (unwrap! vault (err ERR-NOT-ENOUGH))))
                (map-set vaults { id: id } {
                    owner: (get owner v),
                    goal: (get goal v),
                    balance: (+ (get balance v) amount),
                    unlock-block: (get unlock-block v),
                })
            )
            (ok true)
        )
    )
)

;; Withdraw only after unlock
(define-public (withdraw
        (id uint)
        (amount uint)
    )
    (let ((vault (map-get? vaults { id: id })))
        (begin
            (asserts! (is-some vault) (err ERR-NOT-ENOUGH))
            (let ((v (unwrap! vault (err ERR-NOT-ENOUGH))))
                (asserts! (is-eq tx-sender (get owner v)) (err ERR-NOT-OWNER))
                (asserts! (>= burn-block-height (get unlock-block v))
                    (err ERR-TOO-EARLY)
                )
                (asserts! (<= amount (get balance v)) (err ERR-NOT-ENOUGH))
                (as-contract (stx-transfer? amount (contract-caller) (get owner v)))
                (map-set vaults { id: id } {
                    owner: (get owner v),
                    goal: (get goal v),
                    balance: (- (get balance v) amount),
                    unlock-block: (get unlock-block v),
                })
            )
            (ok true)
        )
    )
)

;; --- views ---
(define-read-only (get-vault (id uint))
    (map-get? vaults { id: id })
)

(define-read-only (get-count)
    (var-get vault-count)
)