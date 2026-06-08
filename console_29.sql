SET search_path TO bai5_ss8;


CREATE OR REPLACE PROCEDURE calculate_bonus(p_emp_id INT, p_percent NUMERIC, OUT p_bonus NUMERIC)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_salary NUMERIC(15, 2) ;
BEGIN

    SELECT e.salary
    INTO v_salary
    FROM employees e
    WHERE e.id = p_emp_id;

    IF NOT FOUND
    THEN
        RAISE NOTICE 'Employee not found';
        RETURN;
    END IF;

    IF p_percent <= 0
    THEN
        p_bonus := 0 ;
    ELSE
        p_bonus := v_salary * p_percent / 100;
    END IF;

    ALTER TABLE employees
        ADD COLUMN IF NOT EXISTS bonus NUMERIC;

    UPDATE employees
    SET bonus = p_bonus
    WHERE id = p_emp_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Employee not found';
end;
$$;

DO
$$
    DECLARE
        v_bonus NUMERIC(15, 2);
    BEGIN
        CALL calculate_bonus(4, 30, v_bonus);
        IF v_bonus IS NOT NULL
        THEN
            RAISE NOTICE 'thuong la : %', v_bonus;
        END IF;
    end;
$$;