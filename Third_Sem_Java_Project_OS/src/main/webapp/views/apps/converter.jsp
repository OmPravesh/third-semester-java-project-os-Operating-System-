<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Unit Converter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container text-center">
        <div class="card" style="max-width: 500px; margin: 0 auto;">
            <h3>🔄 Unit Converter</h3>
            
            <div class="form-group mt-2">
                <input type="number" id="inputValue" placeholder="Value" style="padding: 10px; width: 80%; margin-bottom: 10px;">
            </div>
            
            <div class="form-group">
                <select id="conversionType" style="padding: 10px; width: 85%;">
                    <option value="c_to_f">Celsius to Fahrenheit</option>
                    <option value="f_to_c">Fahrenheit to Celsius</option>
                    <option value="m_to_ft">Meters to Feet</option>
                    <option value="ft_to_m">Feet to Meters</option>
                    <option value="kg_to_lb">Kilograms to Pounds</option>
                </select>
            </div>
            
            <button onclick="convert()" class="btn btn-primary mt-2">Convert</button>
            
            <div id="result" style="margin-top: 20px; font-size: 1.5rem; font-weight: bold; color: var(--google-blue);">
                ---
            </div>
        </div>
    </div>

<script>
    function convert() {
        const val = parseFloat(document.getElementById('inputValue').value);
        const type = document.getElementById('conversionType').value;
        let res = 0;
        let unit = "";

        if(isNaN(val)) { alert("Please enter a number"); return; }

        switch(type) {
            case 'c_to_f': res = (val * 9/5) + 32; unit = "°F"; break;
            case 'f_to_c': res = (val - 32) * 5/9; unit = "°C"; break;
            case 'm_to_ft': res = val * 3.28084; unit = "ft"; break;
            case 'ft_to_m': res = val / 3.28084; unit = "m"; break;
            case 'kg_to_lb': res = val * 2.20462; unit = "lbs"; break;
        }
        
        document.getElementById('result').innerText = res.toFixed(2) + " " + unit;
    }
</script>
</body>
</html>