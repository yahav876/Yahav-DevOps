function get() {
    // XMLHttpRequest - 
    let req = new XMLHttpRequest();

    // XMLHttpRequest.open(method: string, url: string)
    req.open('GET', 'http://localhost:3000/all');

    req.onreadystatechange = () => {
        // readyState of 4 - DONE (operation is complete).
        if (req.readyState === 4) {
            // req.response - is the data that returns from the address
            // JSON.parse() - convert to array. 
            let arr = JSON.parse(req.response);
            let result = '';
            result += `${arr}`
            result = result.split(',');
            //console.log(result);
            document.getElementById('link').href = result[0];
            document.getElementById('link').innerHTML = result[0];
            document.getElementById('pass').innerHTML = result[1];
            document.getElementById('email').innerHTML = result[2];
        }
    }
    req.send();
}

