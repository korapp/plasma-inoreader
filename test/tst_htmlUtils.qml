import QtQuick 2.0
import QtTest 1.2

import "../package/contents/code/htmlUtils.js" as H

TestCase {
    name: "HTMLUtils"

    readonly property string imgSampleData: '<section><img width="40" height="30" src="first.jpg" alt="some text"><img src="second.jpg">Test    content</section>'

    function test_findImage() {
        compare(H.findImage(imgSampleData), "first.jpg")
    }

    function test_removeImages() {
        compare(H.removeImages(imgSampleData), '<section>Test    content</section>')
    }

    function test_adjustImages() {
        const result = '<section><img src="first.jpg" width="100" height="auto"><img src="second.jpg" width="100" height="auto">Test    content</section>'
        compare(H.adjustImages(result, 100), result)
    }

    function test_plainText() {
        const plain = H.plainText(imgSampleData, 6, '.')
        compare(plain, 'Test c.')
        compare(plain.length, 7)
    }

    function test_unescapeEntities() {
        const string = "begin&and;test&#x03c3;end"
        const result = "begin⊥testσend"
        compare(H.unescapeEntities(string), result)
    }
}