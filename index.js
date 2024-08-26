$(function() {
    window.addEventListener('message', function(event) {
        var item = event.data;
        console.log("Received message:", item);
        if (item.type === "showWarning") {
            if (item.display) {
                $('#warning-container').html(`
                    <div class="warning-content">
                        <img src="logo.png">
                        <h2>The use of <strong>'Screen Kill Effects'</strong> is forbidden on our server!</h2>
                        <br>
                        <div>
                            <ul>
                                <li>1. Open Settings ( [ESC] / Settings )</li>
                                <li>2. Open <strong>display</strong> tab </li>
                                <li>3. Set <strong>'Screen Kill Effects'</strong> to <strong>OFF</strong> </li>
                                <li>4. Press F8 and type <strong>/checkkilleffects</strong> to verify the change</li>
                            </ul>
                        </div>
                    </div>
                `).show();
                console.log("Showing warning UI");
            } else {
                $('#warning-container').hide().empty();
                console.log("Hiding warning UI");
            }
        }
    });
});