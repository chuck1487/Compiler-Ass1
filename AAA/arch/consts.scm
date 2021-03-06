
(define NL (list->string (list #\newline)))

(define n->s
    (lambda (x)
        (number->string x)))
        
(define sexpr->string
    (lambda (e)
        (format "~a" e)))


;-------------------------------------------------------------------------
;                      Symbol Table
;-------------------------------------------------------------------------    

(define *symbol-table* '())

(define symbol-table-address 0)

(define generate-symbol-table
    (lambda (sym-addr)
        (set! symbol-table-address sym-addr)
        (string-append 
        )
        (cond ((null? *symbol-table*)
                    (string-append 
                        "// *********************************"          NL
                        "//          SYMBOL TABLE "                     NL
                        "// *********************************"          NL NL        

                        
                        "  MOV(R15,IND(0));"                                      NL
                        "  CALL(MAKE_SOB_NIL);"                                    NL
                        "  MOV(IND(R15),IND(R0));"  NL
                    ;    "  MOV(R15,IMM(" (n->s symbol-table-address) "));"        NL
                    
                        "// *********************************"          NL
                        "//          SYMBOL TABLE END"                  NL
                        "// *********************************"          NL NL       
                    )
                )
            (else 
                    (string-append 
                        "// *********************************"          NL
                        "//          SYMBOL TABLE "                     NL
                        "// *********************************"          NL NL        
                        
                        "  MOV(R15,IND(0));"        NL
                        (iter-symbol-table *symbol-table*)
                        
                        "// *********************************"          NL
                        "//          SYMBOL TABLE END"                  NL
                        "// *********************************"          NL NL       

                        
                    ))
        )
                    
    
    ))
    

(define iter-symbol-table
    (lambda (sym-table)
        (if (null? (cdr sym-table))
            (string-append
                "  PUSH(IMM(T_NIL));" NL
                "  PUSH(IMM(" (n->s (car sym-table)) "));" NL
                "  CALL(MAKE_SOB_PAIR);"    NL        
                "  DROP(IMM(2));"           NL NL
                )
            (string-append
                
                "  MOV(R0, IND(0));"    NL
                "  ADD(R0, IMM(3));"    NL
                "  PUSH(R0);"           NL
                "  PUSH(IMM(" (n->s (car sym-table)) "));" NL
                "  CALL(MAKE_SOB_PAIR);"    NL        
                "  DROP(IMM(2));"           NL
                (iter-symbol-table (cdr sym-table))
                ))
     ))
            
        
;-------------------------------------------------------------------------
;                      Const Table
;-------------------------------------------------------------------------

(define get-const
    (lambda (lst)
        (cadr lst)))
        
(define get-addr
    (lambda (lst)
        (car lst)))
        
                                    
(define *base-const-table* `( 
                                (1 ,(void) (|T_VOID|))
                                (2 ,(list) (|T_NIL|))
                                (3 #t (|T_BOOL| 1))
                                (5 #f (|T_BOOL| 0))) )

(define *const-table* '())
                                
(define generate-const-table
  (lambda (ast)
     (set! *const-table* *base-const-table*)
     (set! *symbol-table* '())
     (for-each add-const ast)
     (get-post-addr)
     ))

(define add-const
  (lambda (exp)
    (if (list? exp)
        (cond ((is-const? exp) (set-const! (cadr exp)))
              ((has-list? exp) (for-each add-const exp))))))

(define is-const?
  (lambda (parsed)
    (and (not (null? parsed))
         (equal? (car parsed) 'const))))

(define has-list?
  (lambda (exp)
    (not (null? (filter list? exp)))))

(define last-pair
  (lambda (pair)
    (cond   ((null? (cdr pair)) pair)
            (else
                (last-pair (cdr pair))))
            ))

(define get-post-addr
  (lambda ()
    (let ((last (car (last-pair *const-table*))))
      (+ (car last) (length (flatten (caddr last)))))))

(define get-mem-addr
  (lambda (const)
    (const-iter const *const-table*)))

(define const-iter
  (lambda (const table)
    (if (null? table)
        "Const not found in *const-table"
        (let ((first (car table))
              (rest (cdr table)))
          (if (equal? (get-const first) const)
              (get-addr first)
              (const-iter const rest))))))

(define get-mem-addr-lst
  (lambda (cs)
    (if (null? cs)
        cs
        (cons (get-mem-addr (car cs)) (get-mem-addr-lst (cdr cs))))))

(define set-const!
  (lambda (const)
    (if (not (member const (map cadr *const-table*)))
        (cond ((integer? const)     (add-to-const-table add-integer     const))
              ((pair? const)        (add-to-const-table add-pair        const))
              ((ratnum? const)      (add-to-const-table add-rational    const))
              ((char? const)        (add-to-const-table add-char        const))
              ((symbol? const)      (add-to-const-table add-symbol      const))
              ((string? const)      (add-to-const-table add-string      const))
              ((vector? const)      (add-to-const-table add-vector      const))))))

(define add-to-const-table
  (lambda (exp const)
    (set! *const-table* (append *const-table* `(,(exp const))))))

(define add-integer
  (lambda (int)
    `(,(get-post-addr) ,int (|T_INTEGER| ,int))))

(define add-rational
  (lambda (rat)
    `(,(get-post-addr) ,rat (|T_FRACTION| ,(numerator rat) ,(denominator rat)))))

(define add-pair
  (lambda (p)
    (let ((first (car p))
          (second (cdr p)))
      (begin (set-const! first)
             (set-const! second)
             `(,(get-post-addr) ,p (|T_PAIR| ,(get-mem-addr first) ,(get-mem-addr second)))))))

(define add-vector
  (lambda (v)
    (let ((l (vector->list v)))
      (begin (add-list-iter l)
             `(,(get-post-addr) ,v (|T_VECTOR| ,(vector-length v) ,@(get-mem-addr-lst l)))))))

(define add-char
  (lambda (ch)
    `(,(get-post-addr) ,ch (|T_CHAR| ,(char->integer ch)))))

(define add-symbol
  (lambda (s)
    (let ((str (symbol->string s)))
      (begin (set-const! str)
             (set! *symbol-table* (cons (get-post-addr) *symbol-table*)) 
             `(,(car *symbol-table*) ,s (|T_SYMBOL| ,(get-mem-addr str)))))))

(define add-string
  (lambda (str)
    (let ((lst (string->list str)))
      `(,(get-post-addr) ,str (|T_STRING| ,(string-length str) ,@(map char->integer lst))))))

(define add-list-iter
  (lambda (lst)
    (if (null? lst)
        lst
        (begin (set-const! (car lst))
               (add-list-iter (cdr lst))))))
               
(define generate-const-code
    (lambda (const-list)
        (letrec* (  (stack-location 1)
                    (generate-code
                        (lambda (lst acc)
                            (if (null? lst) acc
                                (generate-code 
                                    (cdr lst) 
                                    (string-append acc (generate-one-code (car lst) stack-location)))
                            )))
                    (generate-one-code
                        (lambda (record location)
                            (let (  (value (cadr record))
                                    (codevalue (caddr record)))
                                (string-append
                                    (generate-one-code-values codevalue location "")
                                )
                            )))
                    (generate-one-code-values
                        (lambda (value location acc)
                                (if (null? value) (begin (set! stack-location location) acc)
                                        (generate-one-code-values 
                                                (cdr value) 
                                                (+ location 1)
                                                (string-append acc
                    "  MOV(IND(" (sexpr->string location) "),IMM(" (sexpr->string (car value)) "));" NL))))))
            
            (generate-code const-list "")
    )))
 
                           
                           
(define lookup-const-table 
    (lambda (const const-table)
                (if (null? const-table) 
                    `(Constant ,const wasn't found in const table)
                    (if (equal? const (get-const (car const-table)))
                        (get-addr (car const-table))
                        (lookup-const-table const  (cdr const-table)))
                )))