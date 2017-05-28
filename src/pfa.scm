(declare (unit parse-fasta))
(declare (uses extras srfi-13))

(define (drop-first-char str)
  (string-drop str 1))

(define (puts-record header seq)
  (format #t ">~a~%~a~%" header seq))

(define (get-record port)
  (define (start-new-record? char)
    (equal? #\> char))
  (define (gr just-started header seq)
    (let ((next-char (peek-char port)))
      (cond ((or (eof-object? next-char)
                 (and (not just-started)
                      (start-new-record? next-char)))
             (values header seq))
            ((start-new-record? next-char)
             (gr #f (drop-first-char (read-line port)) ""))
            (else (gr #f header (string-append seq (read-line port)))))))
  (gr #t "" ""))

(define (each-record fname fn)
  (let ((port (open-input-file fname)))
    (define (each-record-iter)
      (let-values (((header seq) (get-record port)))
        (if (and (string-null? header)
                 (string-null? seq))
            #!eof
            (begin
              (fn header seq)
              (each-record-iter)))))
    (each-record-iter)))

;;;; examples

;; (define fname (car (command-line-arguments)))

;; (each-record fname
;;              (lambda (header seq)
;;                (if (equal? "apple" header)
;;                    (puts-record header seq))))

;; (each-record fname puts-record)
