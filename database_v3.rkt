#lang racket


(struct conection (distance next_station))        ;Connection structure
(struct station (name conection_st))              ;Station Structure


;DEFINITION________________________________________________________________________________
;Line Definition: Stations, Connections and Distances______________________________________

(define A_line (list
            (station "A1" (list (conection 20 "A2")))
            (station "A2" (list (conection 20 "A1")
                                (conection 15 "A3")))
            (station "A3" (list (conection 15 "A2")
                                (conection 30 "A4")))
            (station "A4" (list (conection 30 "A3")
                                (conection 20 "A5")
                                (conection 10 "B6")
                                (conection 10 "B8")))
            (station "A5" (list (conection 20 "A4")
                                (conection 20 "A6")))
            (station "A6" (list (conection 20 "A5")
                                (conection 20 "A7")
                                (conection 10 "D4")))
            (station "A7" (list (conection 20 "A6")
                                (conection 13 "A8")
                                (conection 11 "D3")
                                (conection 12 "E5")))
            (station "A8" (list (conection 13 "A7")
                                (conection 10 "A9")))
            (station "A9" (list (conection 10 "A8")))))



(define B_line (list
                (station "B1" (list (conection 20 "B2")))
                (station "B2" (list (conection 20 "B1")
                                    (conection 15 "B3")))
                (station "B3" (list (conection 15 "B2")
                                    (conection 30"B4")))
                (station "B4" (list (conection 30 "B3")
                                    (conection 20 "B5")))
                (station "B5" (list (conection 30 "B4")
                                    (conection 20 "B6")
                                    (conection 10 "C2")))
                (station "B6" (list (conection 20 "B5")
                                    (conection 10 "A4")))
                (station "A4" (list (conection 30 "A3")
                                    (conection 20 "A5")
                                    (conection 10 "B6")
                                    (conection 10 "B8")))
                (station "B8" (list (conection 10 "A4")
                                    (conection 13 "B9")))
                (station "B9" (list (conection 13 "B8")
                                    (conection 11 "B10")))
                (station "B10" (list (conection 11 "B9")))))


(define C_line (list
                (station "C2" (list (conection 20 "C1")
                                    (conection 10 "B5")))
                (station "C1" (list (conection 20 "C2")))))


(define D_line (list
                (station "D1" (list (conection 10 "D2")))
                (station "D2" (list (conection 10 "D1")
                                    (conection 14 "D3")))
                (station "D3" (list (conection 14 "D2")
                                    (conection 11 "D4")
                                    (conection 11 "A7")
                                    (conection 16 "E2")))
                (station "D4" (list (conection 11 "D3")
                                    (conection 10 "A6")))))



(define E_line (list
                (station "E1" (list (conection 13 "E2")))
                (station "E2" (list (conection 12 "E1")
                                    (conection 16 "D3")))
                (station "D3" (list (conection 14 "D2")
                                    (conection 11 "D4")
                                    (conection 11 "A7")
                                    (conection 16 "E2")))
                (station "A7" (list (conection 20 "A6")
                                    (conection 13 "A8")
                                    (conection 11 "D3")
                                    (conection 12 "E5")))
                (station "E5" (list (conection 12 "A7")
                                    (conection 10 "E6")))
                (station "E6" (list (conection 10 "E5")))))





;PROVIDING_________________________________________________________________________________

(define station_database (list A_line B_line C_line D_line E_line))         ;List of all lines
(provide station_database (struct-out station)  (struct-out conection))     ;Providing of database and structures, outside the file









