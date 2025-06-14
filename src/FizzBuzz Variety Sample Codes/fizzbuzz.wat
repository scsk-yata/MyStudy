(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (func (;1;) (type 0) (param i32) (result i32)
    (local i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    local.tee 1
    i32.store offset=4
    local.get 1
    local.get 0
    i32.store offset=12
    local.get 1
    i32.const 1
    i32.store offset=8
    block  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.load offset=8
        local.get 1
        i32.load offset=12
        i32.gt_s
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.load offset=8
              i32.const 3
              i32.rem_s
              br_if 0 (;@5;)
              local.get 1
              i32.load offset=8
              i32.const 5
              i32.rem_s
              i32.eqz
              br_if 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.load offset=8
                i32.const 3
                i32.rem_s
                i32.eqz
                br_if 0 (;@6;)
                local.get 1
                i32.load offset=8
                i32.const 5
                i32.rem_s
                i32.eqz
                br_if 1 (;@5;)
                local.get 1
                local.get 1
                i32.load offset=8
                i32.store
                i32.const 64
                local.get 1
                call 0
                drop
                br 3 (;@3;)
              end
              i32.const 32
              i32.const 0
              call 0
              drop
              br 2 (;@3;)
            end
            i32.const 48
            i32.const 0
            call 0
            drop
            br 1 (;@3;)
          end
          i32.const 16
          i32.const 0
          call 0
          drop
        end
        i32.const 80
        i32.const 0
        call 0
        drop
        local.get 1
        local.get 1
        i32.load offset=8
        i32.const 1
        i32.add
        i32.store offset=8
        br 0 (;@2;)
      end
    end
    i32.const 0
    local.get 1
    i32.const 16
    i32.add
    i32.store offset=4
    i32.const 0)
  (table (;0;) 0 funcref)
  (memory (;0;) 1)
  (export "memory" (memory 0))
  (export "fizzbuzz" (func 1))
  (data (;0;) (i32.const 16) "FizzBuzz\00")
  (data (;1;) (i32.const 32) "Fizz\00")
  (data (;2;) (i32.const 48) "Buzz\00")
  (data (;3;) (i32.const 64) "%d\00")
  (data (;4;) (i32.const 80) "\0a\00"))
