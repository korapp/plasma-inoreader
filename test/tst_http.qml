import QtQuick 2.0
import QtTest 1.2

import "../package/contents/code/http.mjs" as H

TestCase {
    name: "HTTP"

    function test_urlParams() {
        const params = {
            p1: 1,
            p2: 'a',
            p3: [2,3]
        }
        compare(H.urlParams(params), "p1=1&p2=a&p3=2&p3=3")
    }

}