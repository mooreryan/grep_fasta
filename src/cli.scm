(declare (unit cli))
(declare (uses srfi-1 irregex))

(define (puts str)
  (format #t "~a~%" str))

(define (stderr-puts str)
  (format (current-error-port) "~a~%" str))

(define (puts-usage-msg)
  (format (current-error-port)
          "USAGE: ~a [-e] pattern seqs.fa > subset.fa~%"
          (first (argv))))

(define (abort-with-usg)
  (puts-usage-msg)
  (exit 1))

;; NOTE: this requires that VERSION be set in the calling environment
;; Returns: (values match-fn match header)
(define (parse-cli-args)
  (let ((num-args (length (command-line-arguments))))
    (cond ((and (= num-args 1)
                (or (equal? (first (command-line-arguments))
                            "-v")
                    (equal? (first (command-line-arguments))
                            "--version")))
           (begin
             (format (current-error-port)
                     "~a v~a~%"
                     (first (argv))
                     VERSION)
             (exit 0)))
     ((< num-args 2)
           (begin
             (stderr-puts "ERROR -- Too few args, need at least 2")
             (abort-with-usg)))
          ((= num-args 2) ; regex matching
           (begin
             (stderr-puts "INFO -- Using regular expression matching")
             (values irregex-search
                     (irregex (first (command-line-arguments)))
                     (second (command-line-arguments)))))
          ((and (= num-args 3) ; bad first arg
                (not (equal? "-e" (first (command-line-arguments)))))
           (begin
             (format (current-error-port)
                     "ERROR -- Got 3 args, the first should be '-e' but the first was ~s~%"
                     (first (command-line-arguments)))
             (abort-with-usg)))
          ((= num-args 3) ; exact matching
           (begin
             (stderr-puts "INFO -- Using exact matching")
             (values equal?
                     (second (command-line-arguments))
                     (third (command-line-arguments)))))
          (else (begin
                  (stderr-puts "ERROR -- Too many args...need 2 or 3")
                  (abort-with-usg))))))

(define (abort-unless-file-exists fname)
  (if (not (file-exists? fname))
      (begin
        (format (current-error-port)
                "ERROR -- file '~a' does not exist~%"
                fname)
        (exit 2))))
