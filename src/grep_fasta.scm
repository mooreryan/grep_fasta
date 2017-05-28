(declare (uses parse-fasta cli))

(define VERSION "0.1.0")

(define (puts-record-if-match header seq)
  (if (match-fn match header)
      (puts-record header seq)))

(define-values (match-fn match fname) (parse-cli-args))

(abort-unless-file-exists fname)

(each-record fname puts-record-if-match)
