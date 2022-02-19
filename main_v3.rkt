#lang racket

(require "database_v3.rkt")   ;Require data base



;DATA CONVERSION_______________________________________________________________________
;Converting data from structure to a list fo pairs______________________________________

(define convert (lambda(database format)
                  (cond
                    ((equal? format "pairs")
                      (append* (map(lambda(x)
                                 (append* (map (lambda(y)
                                                 (map (lambda(z)(list (station-name y) z)) 
                                                      (map (lambda(con) (conection-next_station con))(station-conection_st y))))x))) database)))
                    ((equal? format "stations")
                     (map(lambda(x)
                                 (map (lambda(y) (station-name y)) x)) database)))))





;MAIN FUNCTIONS__________________________________________________________________________
;Finding all the intersections of the stations___________________________________________
(define intersection (lambda (station data)
               (map
                (lambda (y) (first(rest y)))
                    (filter
                        (lambda (y) (equal? (first y) station))
                        data))))




;Finding the path, from Start to Finish__________________________________________________

(define path (lambda (x y a-graph vertex-set last_st)
                 (cond
                 ((equal? x y)  (list last_st y) ) 
                 ((not (set-member? vertex-set x)) #f)
                 ((not (set-member? vertex-set y)) #f)
                 (#t(ormap (lambda (z)(path z y a-graph
                      (set-remove vertex-set x) x)) (intersection x a-graph))))))




;Main Function___________________________________________________________________________

(define main (lambda (x y graph res)
                  (define res_pair (path x y graph (list->set (flatten graph)) 0))
  
                  (define result (append  res_pair res))
                           
                  (cond
                    ((equal? x (first res_pair)) result)
                    (else (main x (first res_pair) data_base_list result)))))

                    




;DISTANCE_________________________________________________________________________________
;Converting the result in pairs___________________________________________________________

(define (create_pairs ls)
  (cond
    ((>= (length ls) 2)
     (cons (cons (first ls) (first(rest ls))) (create_pairs (rest(rest ls))) ) )  
    (else '() )))
   


;Searching for distance between stations__________________________________________________

(define (distance pair db)
  (append* (map (lambda(i)  
   (append* (map (lambda(j)                   
     (append* (map (lambda(z)                
        (cond
          ((and (equal? (station-name j) (car pair)) (equal? (cdr pair) (conection-next_station z)))
           (list (conection-distance z))) 
          (else '())))
                   (station-conection_st j)))) i))) db)))
      



;Calculation of the final distance_________________________________________________________

(define (path_distance path_list)
  (foldl + 0
      (append* (map (lambda(i)
           (distance i station_database)) path_list))))
  



;PROVIDING_________________________________________________________________________________

(define data_base_list (convert station_database "pairs"))
(define station_names_list (convert station_database  "stations" ))

(provide station_names_list main data_base_list path_distance create_pairs )





