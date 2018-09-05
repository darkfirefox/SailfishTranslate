function dbInit() {

    var db=LocalStorage.openDatabaseSync("HistoryDB", "1.0", "test", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS historyTranslate (fromL text,fromT text,toL text, toT text)')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("HistoryDB", "",
                                               "test", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}
function dbInsertRow(fromL, fromT, toL,toT){
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
    tx.executeSql('INSERT INTO historyTranslate VALUES(?, ?, ?, ?)',
                          [fromL, fromT, toL,toT])
         var result = tx.executeSql('SELECT last_insert_rowid()')
         rowid = result.insertId
        })
    return rowid;
}

function dbReadAll()
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql(
                    'SELECT rowid,fromL,fromT,toL,toT FROM historyTranslate order by rowid desc')
        for (var i = 0; i < results.rows.length; i++) {
            listModel.append({
                                 id: results.rows.item(i).rowid,
                                 fromL: results.rows.item(i).fromL,
                                 fromT: results.rows.item(i).fromT,
                                 toL: results.rows.item(i).toL,
                                 toT: results.rows.item(i).toT,
                             })
        }
    })
}
function dbDeleteRow(id)
{
    var db = dbGetHandle()
    console.log(id)
    db.transaction(function (tx) {
        tx.executeSql('delete from historyTranslate where rowid = ?', [id])
    })
    console.log("delete")
}
function dbDeleteAll()
{
    var db = dbGetHandle()
    console.log("delete all")
    db.transaction(function (tx){
      tx.executeSql('delete from historyTranslate')
    })
}
