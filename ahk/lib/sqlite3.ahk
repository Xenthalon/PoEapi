;
; sqlite3.ahk, 6/11/2021 1:14 AM
;

class sqlite3 extends AhkObj {

    __new(filename) {
        base.__new()
        this.filename := filename
        this.open(filename)
    }

    exec(sql, args*) {
        result := this.__Call("exec", Format(sql, args*))
        if (result.Count() > 0)
            return result
    }

    exists(sql, args*) {
        result := this.exec(Format(sql, args*))
        if (Not result.errcode && result.Count())
            return true
    }

    get(sql, args*) {
        result := this.exec(Format(sql, args*))
        if (Not result.errcode) {
            for name, value in result[1]
                return value
        }
    }

    listTables() {
        result := this.exec("
            (
            SELECT * FROM sqlite_schema
            WHERE type IN ('table', 'view') AND name NOT LIKE 'sqlite_%'
            ORDER BY 1
            )")

        if (result.Length()) {
            debug("Tables:")
            for i, t in result
                debug("    {:2d}. {}", i, t.name)
        }
    }
}