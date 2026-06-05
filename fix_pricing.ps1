$filePath = "C:\Users\pekop\Documents\antigra-project\upaid\index.html"

# Read the whole file as raw UTF-8 text
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# Split into lines preserving encoding
$lines = $content -split "`n"

# Find the line with the grid div (start of plans)
$startLine = -1
$endLine = -1

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'grid md:grid-cols-3 gap-8 items-stretch' -and $startLine -eq -1) {
        $startLine = $i
    }
    if ($startLine -ne -1 -and $i -gt $startLine + 5 -and $lines[$i] -match 'Portfolio Section') {
        $endLine = $i - 1
        break
    }
}

Write-Host "Start line: $($startLine + 1), End line: $($endLine + 1)"

# Build replacement as byte array to preserve encoding
$replacement = @"
            <div class="grid md:grid-cols-3 gap-8 items-stretch">

                <!-- ライトプラン -->
                <div class="bg-stone-50 rounded-3xl p-8 border border-stone-200 flex flex-col shadow-sm">
                    <div>
                        <span class="text-xs font-bold text-brand-700 bg-brand-100 px-3 py-1 rounded-full uppercase">初期費用を抑えてスタート</span>
                        <h3 class="text-2xl font-bold text-stone-850 mt-4 mb-2">ライトプラン</h3>
                        <p class="text-sm text-stone-500 mb-6">店舗や企業の「名刺代わり」となる基本セット</p>
                        <div class="mb-6 flex items-baseline">
                            <span class="text-3xl font-bold text-stone-850">50,000</span>
                            <span class="text-xl font-medium text-stone-800">円</span>
                            <span class="text-xs text-stone-400 ml-2">（初期制作費・税別）</span>
                        </div>
                        <ul class="space-y-3.5 text-sm text-stone-700 border-t border-stone-200 pt-6 mb-6">
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>スマートフォン対応（レスポンシブ）など</li>
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>７ページ（セクション）以内、画像7枚以内</li>
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>基本的なSEO対策設定など</li>
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>Googleマップ・SNSリンク連携など</li>
                        </ul>
                        <!-- 管理・更新サポート（ライトプラン） -->
                        <div class="bg-stone-100 rounded-2xl p-5 border border-stone-300">
                            <span class="text-xs font-bold text-stone-600 bg-stone-200 px-2 py-0.5 rounded-full">保守・管理・ちょっとした修正</span>
                            <h4 class="text-base font-bold text-stone-850 mt-2 mb-1">管理・更新サポート</h4>
                            <p class="text-xs text-stone-500 mb-3">制作後の管理・サーバードメイン維持・更新代行</p>
                            <div class="mb-3 flex items-baseline">
                                <span class="text-xs text-stone-500 mr-1">月額</span>
                                <span class="text-xl font-bold text-stone-850">3,000</span>
                                <span class="text-sm font-medium text-stone-800">円〜</span>
                                <span class="text-xs text-stone-400 ml-1">（税別）</span>
                            </div>
                            <ul class="space-y-1.5 text-xs text-stone-700 border-t border-stone-200 pt-3">
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>サーバー・ドメインの維持＆管理代行</li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg><span class="font-bold">LINEで簡単・手軽に修正依頼OK</span></li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>軽微な文章・画像修正代行（無料）</li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>営業時間変更、お知らせ更新等に即対応</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- スタンダードプラン -->
                <div class="bg-stone-50 rounded-3xl p-8 border border-stone-200 flex flex-col shadow-sm">
                    <div>
                        <span class="text-xs font-bold text-brand-700 bg-brand-100 px-3 py-1 rounded-full uppercase">集客・信頼性を高める本格仕様</span>
                        <h3 class="text-2xl font-bold text-stone-850 mt-4 mb-2">スタンダードプラン</h3>
                        <p class="text-sm text-stone-500 mb-6">ビジネスの「顔」として機能する標準セット</p>
                        <div class="mb-6 flex items-baseline">
                            <span class="text-3xl font-bold text-stone-850">要相談</span>
                            <span class="text-xl font-medium text-stone-800">円</span>
                            <span class="text-xs text-stone-400 ml-2">（要相談）</span>
                        </div>
                        <ul class="space-y-3.5 text-sm text-stone-700 border-t border-stone-200 pt-6 mb-6">
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>独自ドメイン取得</li>
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>15ページ以内（お知らせ枠含む）</li>
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>Googleマップ・SNS連携 ＋ お問い合わせフォーム</li>
                        </ul>
                        <!-- 管理・更新サポート（スタンダードプラン） -->
                        <div class="bg-stone-100 rounded-2xl p-5 border border-stone-300">
                            <span class="text-xs font-bold text-stone-600 bg-stone-200 px-2 py-0.5 rounded-full">保守・管理・ちょっとした修正</span>
                            <h4 class="text-base font-bold text-stone-850 mt-2 mb-1">管理・更新サポート</h4>
                            <p class="text-xs text-stone-500 mb-3">制作後の管理・サーバードメイン維持・更新代行</p>
                            <div class="mb-3 flex items-baseline">
                                <span class="text-xs text-stone-500 mr-1">月額</span>
                                <span class="text-xl font-bold text-stone-850">4,000</span>
                                <span class="text-sm font-medium text-stone-800">円</span>
                                <span class="text-xs text-stone-400 ml-1">（税別）</span>
                            </div>
                            <ul class="space-y-1.5 text-xs text-stone-700 border-t border-stone-200 pt-3">
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>サーバー・ドメインの維持＆管理代行</li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg><span class="font-bold">LINEで簡単・手軽に修正依頼OK</span></li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>軽微な文章・画像修正代行（無料）</li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>営業時間変更、お知らせ更新等に即対応</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- カスタムプラン -->
                <div class="bg-stone-50 rounded-3xl p-8 border border-stone-200 flex flex-col shadow-sm">
                    <div>
                        <span class="text-xs font-bold text-brand-700 bg-brand-100 px-3 py-1 rounded-full uppercase">こだわりを形にする完全自由設計</span>
                        <h3 class="text-2xl font-bold text-stone-850 mt-4 mb-2">カスタムプラン</h3>
                        <p class="text-sm text-stone-500 mb-6">完全オリジナルデザイン</p>
                        <div class="mb-6 flex items-baseline">
                            <span class="text-3xl font-bold text-stone-850">要相談</span>
                            <span class="text-xl font-medium text-stone-800">円</span>
                            <span class="text-xs text-stone-400 ml-2">（要相談）</span>
                        </div>
                        <ul class="space-y-3.5 text-sm text-stone-700 border-t border-stone-200 pt-6 mb-6">
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>完全オリジナルデザイン</li>
                            <li class="flex items-center"><svg class="w-4 h-4 mr-2 text-brand-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>ページ（セクション）制限なし</li>
                        </ul>
                        <!-- 管理・更新サポート（カスタムプラン） -->
                        <div class="bg-stone-100 rounded-2xl p-5 border border-stone-300">
                            <span class="text-xs font-bold text-stone-600 bg-stone-200 px-2 py-0.5 rounded-full">保守・管理・ちょっとした修正</span>
                            <h4 class="text-base font-bold text-stone-850 mt-2 mb-1">管理・更新サポート</h4>
                            <p class="text-xs text-stone-500 mb-3">制作後の管理・サーバードメイン維持・更新代行</p>
                            <div class="mb-3 flex items-baseline">
                                <span class="text-xs text-stone-500 mr-1">月額</span>
                                <span class="text-xl font-bold text-stone-850">5,000</span>
                                <span class="text-sm font-medium text-stone-800">円〜</span>
                                <span class="text-xs text-stone-400 ml-1">（税別）</span>
                            </div>
                            <ul class="space-y-1.5 text-xs text-stone-700 border-t border-stone-200 pt-3">
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>サーバー・ドメインの維持＆管理代行</li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg><span class="font-bold">LINEで簡単・手軽に修正依頼OK</span></li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>軽微な文章・画像修正代行（無料）</li>
                                <li class="flex items-center"><svg class="w-3 h-3 mr-1.5 text-stone-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>営業時間変更、お知らせ更新等に即対応</li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>

            <p class="text-xs text-stone-400 text-center mt-8">※ドメインの種類や、大幅なページの追加、複雑なシステム開発を伴う場合は別途お見積もりとなります。</p>
        </div>
    </section>
"@

# Reconstruct the file
$before = ($lines[0..($startLine - 1)]) -join "`n"
$after = ($lines[$endLine..($lines.Length - 1)]) -join "`n"
$newContent = $before + "`n" + $replacement + "`n" + $after

# Write with UTF-8 no BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($filePath, $newContent, $utf8NoBom)
Write-Host "Done! File written with UTF-8 encoding."
