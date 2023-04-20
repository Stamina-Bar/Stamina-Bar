//
//  StaminaBarView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 4/18/23.
//

// MARK: Algorithm for Displaying general Stamina Bar:
// i = (m - n) / 100 where m = 168, n = 65 (bpm)



import Foundation
import SwiftUI


class StaminaBarView {
            
        let messages = [
            " ",
            " "
        ]
        
        func visualizeHeartRate(data: CGFloat) -> AnyView {
            let messageIndex: Int
            let imageName: String
            
            
            
            switch data {
                case ..<65:
                    imageName = "100"
                    messageIndex = 0
                case 65..<67:
                    imageName = "99"
                    messageIndex = 0
                case 67..<69:
                    imageName = "98"
                    messageIndex = 0
                case 69..<71:
                    imageName = "97"
                    messageIndex = 0
                case 71..<73:
                    imageName = "96"
                    messageIndex = 0
                case 73..<74:
                    imageName = "95"
                    messageIndex = 0
                case 74..<75:
                    messageIndex = 0
                    imageName = "94"
                case 75..<77:
                    imageName = "93"
                    messageIndex = 0
                case 77..<79:
                    messageIndex = 0
                    imageName = "92"
                case 79..<80:
                    imageName = "91"
                    messageIndex = 0
                case 80..<81:
                    messageIndex = 0
                    imageName = "90"
                case 81..<82:
                    messageIndex = 0
                    imageName = "89"
                case 82..<83:
                    messageIndex = 0
                    imageName = "88"
                case 83..<84:
                    messageIndex = 0
                    imageName = "87"
                case 84..<85:
                    messageIndex = 0
                    imageName = "86"
                case 85..<86:
                    messageIndex = 0
                    imageName = "85"
                case 86..<87:
                    messageIndex = 0
                    imageName = "84"
                case 87..<88:
                    messageIndex = 0
                    imageName = "83"
                case 88..<89:
                    messageIndex = 1
                    imageName = "82"
                    // Image to relax.
                case 89..<90:
                    imageName = "81"
                    messageIndex = 1
                case 90..<91:
                    imageName = "80"
                    messageIndex = 1
                case 91..<92:
                    imageName = "79"
                    messageIndex = 1
                case 92..<93:
                    imageName = "78"
                    messageIndex = 1
                case 93..<94:
                    imageName = "77"
                    messageIndex = 1
                case 94..<95:
                    imageName = "76"
                    messageIndex = 1
                case 95..<96:
                    imageName = "75"
                    messageIndex = 1
                case 96..<97:
                    imageName = "74"
                    messageIndex = 1
                case 97..<98:
                    imageName = "73"
                    messageIndex = 1
                case 98..<99:
                    imageName = "72"
                    messageIndex = 1
                case 99..<100:
                    imageName = "71"
                    messageIndex = 1
                case 100..<101:
                    imageName = "70"
                    messageIndex = 1
                case 101..<102:
                    messageIndex = 1
                    imageName = "69"
                case 102..<103:
                    messageIndex = 1
                    imageName = "68"
                case 103..<104:
                    messageIndex = 1
                    imageName = "67"
                case 104..<105:
                    messageIndex = 1
                    imageName = "66"
                case 105..<106:
                    imageName = "65"
                    messageIndex = 1
                case 106..<107:
                    messageIndex = 1
                    imageName = "64"
                case 107..<108:
                    messageIndex = 1
                    imageName = "63"
                case 108..<109:
                    messageIndex = 1
                    imageName = "62"
                case 109..<110:
                    messageIndex = 1
                    imageName = "61"
                case 110..<111:
                    messageIndex = 1
                    imageName = "60"
                case 111..<112:
                    messageIndex = 1
                    imageName = "59"
                case 112..<113:
                    messageIndex = 1
                    imageName = "58"
                case 113..<114:
                    messageIndex = 1
                    imageName = "57"
                case 114..<115:
                    messageIndex = 1
                    imageName = "56"
                case 115..<116:
                    imageName = "55"
                    messageIndex = 1
                case 116..<117:
                    messageIndex = 1
                    imageName = "54"
                case 117..<118:
                    imageName = "53"
                    messageIndex = 1
                case 118..<119:
                    messageIndex = 1
                    imageName = "52"
                case 119..<120:
                    messageIndex = 1
                    imageName = "51"
                case 120..<121:
                    imageName = "50"
                    messageIndex = 1
                case 121..<122:
                    messageIndex = 1
                    imageName = "49"
                case 122..<123:
                    messageIndex = 1
                    imageName = "48"
                case 123..<124:
                    messageIndex = 1
                    imageName = "47"
                case 124..<125:
                    messageIndex = 1
                    imageName = "46"
                case 125..<126:
                    messageIndex = 1
                    imageName = "45"
                case 126..<127:
                    messageIndex = 1
                    imageName = "44"
                case 127..<128:
                    messageIndex = 1
                    imageName = "43"
                case 128..<129:
                    messageIndex = 1
                    imageName = "42"
                case 129..<130:
                    messageIndex = 1
                    imageName = "40"
                case 130..<131:
                    messageIndex = 1
                    imageName = "39"
                case 131..<132:
                    messageIndex = 1
                    imageName = "38"
                case 132..<133:
                    messageIndex = 1
                    imageName = "37"
                case 133..<134:
                    messageIndex = 1
                    imageName = "36"
                case 134..<135:
                    messageIndex = 1
                    imageName = "35"
                case 135..<136:
                    messageIndex = 1
                    imageName = "34"
                case 136..<137:
                    messageIndex = 1
                    imageName = "33"
                case 137..<138:
                    messageIndex = 1
                    imageName = "32"
                case 138..<139:
                    messageIndex = 1
                    imageName = "31"
                case 139..<140:
                    messageIndex = 1
                    imageName = "30"
                case 140..<141:
                    messageIndex = 1
                    imageName = "29"
                case 141..<142:
                    messageIndex = 1
                    imageName = "28"
                case 142..<143:
                    messageIndex = 1
                    imageName = "27"
                case 143..<144:
                    messageIndex = 1
                    imageName = "26"
                case 144..<145:
                    messageIndex = 1
                    imageName = "25"
                case 145..<146:
                    messageIndex = 1
                    imageName = "24"
                case 146..<147:
                    messageIndex = 1
                    imageName = "23"
                case 147..<148:
                    messageIndex = 1
                    imageName = "22"
                case 148..<149:
                    messageIndex = 1
                    imageName = "21"
                case 149..<150:
                    messageIndex = 1
                    imageName = "20"
                case 150..<151:
                    messageIndex = 1
                    imageName = "19"
                case 151..<152:
                    messageIndex = 1
                    imageName = "18"
                case 152..<153:
                    messageIndex = 1
                    imageName = "17"
                case 153..<154:
                    messageIndex = 1
                    imageName = "16"
                case 154..<155:
                    messageIndex = 1
                    imageName = "15"
                case 155..<156:
                    messageIndex = 1
                    imageName = "14"
                case 156..<157:
                    messageIndex = 1
                    imageName = "13"
                case 157..<158:
                    messageIndex = 1
                    imageName = "12"
                case 158..<159:
                    messageIndex = 1
                    imageName = "11"
                case 159..<160:
                    messageIndex = 1
                    imageName = "10"
                case 160..<161:
                    messageIndex = 1
                    imageName = "9"
                case 161..<162:
                    messageIndex = 1
                    imageName = "8"
                case 162..<163:
                    messageIndex = 1
                    imageName = "7"
                case 163..<164:
                    messageIndex = 1
                    imageName = "6"
                case 164..<165:
                    messageIndex = 1
                    imageName = "5"
                case 165..<166:
                    messageIndex = 1
                    imageName = "4"
                case 166..<167:
                    messageIndex = 1
                    imageName = "3"
                case 167..<168:
                    messageIndex = 1
                    imageName = "2"
                case 167..<169:
                    messageIndex = 1
                    imageName = "1"

            default:
                return AnyView(Text("Invalid Value"))
            }
            
            let message = messages[messageIndex]
            
            return AnyView(VStack(alignment: .leading) {
                Image(imageName)
                Text(message)
                    .font(.system(size: 12))
                    
            })
        }
        
    }


    
//
//switch data {
//case ..<65:
//    imageName = "100"
//case 65..<67:
//    imageName = "99"
//case 67..<69:
//    imageName = "98"
//case 69..<71:
//    imageName = "97"
//case 71..<73:
//    imageName = "96"
//case 73..<74:
//    imageName = "95"
//case 74..<75:
//    imageName = "94"
//case 75..<77:
//    imageName = "93"
//case 77..<79:
//    imageName = "92"
//case 79..<80:
//    imageName = "91"
//case 80..<81:
//    imageName = "90"
//case 81..<82:
//    imageName = "89"
//case 82..<83:
//    imageName = "88"
//case 83..<84:
//    imageName = "87"
//case 84..<85:
//    imageName = "86"
//case 85..<86:
//    imageName = "85"
//case 86..<87:
//    imageName = "84"
//case 87..<88:
//    imageName = "83"
//case 88..<89:
//    imageName = "82"
//    // Image to relax.
//    messageIndex = 4
//case 89..<90:
//    imageName = "81"
//    messageIndex = 4
//case 90..<91:
//    imageName = "80"
//    messageIndex = 4
//case 91..<92:
//    imageName = "79"
//    messageIndex = 4
//case 92..<93:
//    imageName = "78"
//    messageIndex = 4
//case 93..<94:
//    imageName = "77"
//    messageIndex = 4
//case 94..<95:
//    imageName = "76"
//    messageIndex = 4
//case 95..<96:
//    imageName = "75"
//    messageIndex = 4
//case 96..<97:
//    imageName = "74"
//    messageIndex = 4
//case 97..<98:
//    imageName = "73"
//    messageIndex = 4
//case 98..<99:
//    imageName = "72"
//    messageIndex = 4
//case 99..<100:
//    imageName = "71"
//    messageIndex = 4
//case 100..<101:
//    imageName = "70"
//case 101..<102:
//    imageName = "69"
//case 102..<103:
//    imageName = "68"
//case 103..<104:
//    imageName = "67"
//case 104..<105:
//    imageName = "66"
//case 105..<106:
//    imageName = "65"
//case 106..<107:
//    imageName = "64"
//case 107..<108:
//    imageName = "63"
//case 108..<109:
//    imageName = "62"
//case 109..<110:
//    imageName = "61"
//case 110..<111:
//    imageName = "60"
//case 111..<112:
//    imageName = "59"
//case 112..<113:
//    imageName = "58"
//case 113..<114:
//    imageName = "57"
//case 114..<115:
//    imageName = "56"
//case 115..<116:
//    imageName = "55"
//case 116..<117:
//    imageName = "54"
//case 117..<118:
//    imageName = "53"
//case 118..<119:
//    imageName = "52"
//case 119..<120:
//    imageName = "51"
//case 120..<121:
//    imageName = "50"
//case 121..<122:
//    imageName = "49"
//case 122..<123:
//    imageName = "48"
//case 123..<124:
//    imageName = "47"
//case 124..<125:
//    imageName = "46"
//case 125..<126:
//    imageName = "45"
//case 126..<127:
//    imageName = "44"
//case 127..<128:
//    imageName = "43"
//case 128..<129:
//    imageName = "42"
//case 129..<130:
//    imageName = "40"
//case 130..<131:
//    imageName = "39"
//case 131..<132:
//    imageName = "38"
//case 132..<133:
//    imageName = "37"
//case 133..<134:
//    imageName = "36"
//case 134..<135:
//    imageName = "35"
//case 135..<136:
//    imageName = "34"
//case 136..<137:
//    imageName = "33"
//case 137..<138:
//    imageName = "32"
//case 138..<139:
//    imageName = "31"
//case 139..<140:
//    imageName = "30"
//case 140..<141:
//    imageName = "29"
//case 141..<142:
//    imageName = "28"
//case 142..<143:
//    imageName = "27"
//case 143..<144:
//    imageName = "26"
//case 144..<145:
//    imageName = "25"
//case 145..<146:
//    imageName = "24"
//case 146..<147:
//    imageName = "23"
//case 147..<148:
//    imageName = "22"
//case 148..<149:
//    imageName = "21"
//case 149..<150:
//    imageName = "20"
//case 150..<151:
//    imageName = "19"
//case 151..<152:
//    imageName = "18"
//case 152..<153:
//    imageName = "17"
//case 153..<154:
//    imageName = "16"
//case 154..<155:
//    imageName = "15"
//case 155..<156:
//    imageName = "14"
//case 156..<157:
//    imageName = "13"
//case 157..<158:
//    imageName = "12"
//case 158..<159:
//    imageName = "11"
//case 159..<160:
//    imageName = "10"
//case 160..<161:
//    imageName = "9"
//case 161..<162:
//    imageName = "8"
//case 162..<163:
//    imageName = "7"
//case 163..<164:
//    imageName = "6"
//case 164..<165:
//    imageName = "5"
//case 165..<166:
//    imageName = "4"
//case 166..<167:
//    imageName = "3"
//case 167..<168:
//    imageName = "2"
//case 167..<169:
//    imageName = "1"
//default:
//    return AnyView(Image("100"))
//}
