function countSpace(str){
    let count = 0
    for (let i = 0; i < str.length; i++) {
        if (str[i] == ' ') {
            count++
        }
    }
    return count
}

console.log(countSpace("This is a pen."))
