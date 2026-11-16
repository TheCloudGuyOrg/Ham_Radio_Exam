#!/bin/bash
# Build a single self-contained HTML file with embedded questions and figures
DIR="$(cd "$(dirname "$0")" && pwd)"

# Base64 encode the figures
E51=$(base64 -i "$DIR/E5-1.png" | tr -d '\n')
E61=$(base64 -i "$DIR/E6-1.png" | tr -d '\n')
E62=$(base64 -i "$DIR/E6-2.png" | tr -d '\n')
E63=$(base64 -i "$DIR/E6-3.png" | tr -d '\n')
E71=$(base64 -i "$DIR/E7-1.png" | tr -d '\n')
E72=$(base64 -i "$DIR/E7-2.png" | tr -d '\n')
E73=$(base64 -i "$DIR/E7-3.png" | tr -d '\n')
E91=$(base64 -i "$DIR/E9-1.png" | tr -d '\n')
E92=$(base64 -i "$DIR/E9-2.png" | tr -d '\n')
E93=$(base64 -i "$DIR/E9-3.png" | tr -d '\n')

cat > "$DIR/index.html" << 'HTMLPART1'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Extra Class Practice Exam (2024-2028)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#1a1a2e;color:#e0e0e0;min-height:100vh;padding:20px}
.container{max-width:800px;margin:0 auto}
h1{text-align:center;color:#00d4ff;margin-bottom:8px;font-size:1.8rem}
.subtitle{text-align:center;color:#888;margin-bottom:30px;font-size:0.9rem}
#setup{background:#16213e;border-radius:12px;padding:40px;text-align:center;border:1px solid #0f3460}
#setup h2{color:#00d4ff;margin-bottom:20px}
#setup p{color:#aaa;margin-bottom:24px;line-height:1.6}
.preset-buttons{display:flex;flex-wrap:wrap;gap:12px;justify-content:center;margin-bottom:24px}
.preset-btn{background:#0f3460;border:2px solid #00d4ff;color:#00d4ff;padding:12px 24px;border-radius:8px;font-size:1rem;cursor:pointer;transition:all 0.2s}
.preset-btn:hover{background:#00d4ff;color:#1a1a2e}
.custom-input{display:flex;align-items:center;justify-content:center;gap:12px;margin-top:16px}
.custom-input input{width:80px;padding:10px;border-radius:8px;border:2px solid #0f3460;background:#1a1a2e;color:#e0e0e0;font-size:1rem;text-align:center}
.custom-input button{background:#e94560;border:none;color:white;padding:10px 20px;border-radius:8px;font-size:1rem;cursor:pointer}
.custom-input button:hover{background:#ff6b6b}
.section-filter{margin-top:28px;padding-top:24px;border-top:1px solid #0f3460;text-align:left}
.section-filter h3{color:#00d4ff;margin-bottom:8px;text-align:center}
.section-groups{display:flex;flex-wrap:wrap;gap:8px;justify-content:center;margin-bottom:16px}
.section-chip{display:inline-flex;align-items:center;gap:6px;background:#1a1a2e;border:2px solid #0f3460;color:#aaa;padding:8px 14px;border-radius:8px;font-size:0.85rem;cursor:pointer;transition:all 0.2s;user-select:none}
.section-chip:hover{border-color:#00d4ff;color:#e0e0e0}
.section-chip.active{border-color:#00d4ff;background:#0f3460;color:#00d4ff}
.section-chip input{display:none}
.section-chip .chip-count{font-size:0.75rem;color:#666}
.section-chip.active .chip-count{color:#00d4ff}
.section-actions{display:flex;gap:10px;justify-content:center}
.section-action-btn{background:transparent;border:1px solid #0f3460;color:#888;padding:6px 14px;border-radius:6px;font-size:0.8rem;cursor:pointer;transition:all 0.2s}
.section-action-btn:hover{border-color:#00d4ff;color:#00d4ff}
#quiz{display:none}
.progress-bar{background:#0f3460;border-radius:20px;height:8px;margin-bottom:20px;overflow:hidden}
.progress-fill{background:linear-gradient(90deg,#00d4ff,#e94560);height:100%;border-radius:20px;transition:width 0.3s}
.question-info{display:flex;justify-content:space-between;margin-bottom:12px;font-size:0.85rem;color:#888}
.question-card{background:#16213e;border-radius:12px;padding:30px;border:1px solid #0f3460;margin-bottom:20px}
.question-id{color:#00d4ff;font-size:0.8rem;font-weight:600;margin-bottom:12px}
.question-text{font-size:1.15rem;line-height:1.5;margin-bottom:24px;color:#fff}
.question-figure{margin-bottom:20px;text-align:center}
.question-figure img{max-width:100%;border-radius:8px;background:#fff;padding:10px}
.answers{display:flex;flex-direction:column;gap:10px}
.answer-btn{background:#1a1a2e;border:2px solid #0f3460;color:#e0e0e0;padding:14px 18px;border-radius:8px;text-align:left;font-size:1rem;cursor:pointer;transition:all 0.2s;line-height:1.4}
.answer-btn:hover:not(.disabled){border-color:#00d4ff;background:#0f3460}
.answer-btn.correct{border-color:#4caf50;background:rgba(76,175,80,0.15);color:#4caf50}
.answer-btn.incorrect{border-color:#e94560;background:rgba(233,69,96,0.15);color:#e94560}
.answer-btn.disabled{cursor:default}
.answer-letter{display:inline-block;width:28px;height:28px;line-height:28px;text-align:center;border-radius:50%;background:#0f3460;color:#00d4ff;font-weight:600;margin-right:12px;font-size:0.85rem}
.feedback{margin-top:16px;padding:14px;border-radius:8px;display:none;font-size:0.95rem}
.feedback.correct-fb{display:block;background:rgba(76,175,80,0.1);border:1px solid #4caf50;color:#4caf50}
.feedback.incorrect-fb{display:block;background:rgba(233,69,96,0.1);border:1px solid #e94560;color:#e94560}
.ref-text{color:#888;font-size:0.8rem;margin-top:8px}
.next-btn{display:none;margin-top:20px;background:#00d4ff;border:none;color:#1a1a2e;padding:14px 32px;border-radius:8px;font-size:1rem;font-weight:600;cursor:pointer;width:100%}
.next-btn:hover{background:#33dfff}
#results{display:none}
.results-card{background:#16213e;border-radius:12px;padding:40px;text-align:center;border:1px solid #0f3460}
.score-circle{width:160px;height:160px;border-radius:50%;margin:0 auto 24px;display:flex;align-items:center;justify-content:center;font-size:2.5rem;font-weight:700}
.score-circle.pass{border:6px solid #4caf50;color:#4caf50}
.score-circle.fail{border:6px solid #e94560;color:#e94560}
.results-text{font-size:1.2rem;margin-bottom:8px}
.results-detail{color:#888;margin-bottom:30px}
.results-actions{display:flex;gap:12px;justify-content:center;flex-wrap:wrap}
.results-actions button{padding:12px 24px;border-radius:8px;font-size:1rem;cursor:pointer;border:none}
.btn-primary{background:#00d4ff;color:#1a1a2e;font-weight:600}
.btn-primary:hover{background:#33dfff}
.btn-secondary{background:#0f3460;color:#00d4ff;border:2px solid #00d4ff !important}
.btn-secondary:hover{background:#00d4ff;color:#1a1a2e}
.review-section{margin-top:30px;text-align:left}
.review-section h3{color:#e94560;margin-bottom:16px}
.review-item{background:#1a1a2e;border-radius:8px;padding:16px;margin-bottom:12px;border:1px solid #0f3460}
.review-item .q-id{color:#00d4ff;font-size:0.8rem;font-weight:600}
.review-item .q-text{margin:8px 0;font-size:0.95rem}
.review-item .your-answer{color:#e94560;font-size:0.9rem}
.review-item .correct-answer{color:#4caf50;font-size:0.9rem}
</style>
</head>
<body>
<div class="container">
<h1>Extra Class Practice Exam</h1>
<p class="subtitle">2024-2028 Question Pool &#8226; 599 Questions &#8226; Effective July 1, 2024</p>
<div id="setup">
<h2>How many questions?</h2>
<p>The actual exam is 50 questions (must score 37/50 to pass).<br>Choose a preset or enter a custom number.</p>
<div class="preset-buttons">
<button class="preset-btn" onclick="startQuiz(10)">10</button>
<button class="preset-btn" onclick="startQuiz(25)">25</button>
<button class="preset-btn" onclick="startQuiz(50)">50 (Full Exam)</button>
<button class="preset-btn" onclick="startQuiz(75)">75</button>
<button class="preset-btn" onclick="startQuiz(100)">100</button>
</div>
<div class="custom-input">
<label for="customCount" style="color:#aaa;">Custom:</label>
<input type="number" id="customCount" min="1" max="599" value="50">
<button onclick="startQuiz(parseInt(document.getElementById('customCount').value))">Start</button>
</div>
<div class="section-filter">
<h3>Filter by Section <span style="font-weight:normal;font-size:0.85rem;color:#888;">(optional)</span></h3>
<p style="color:#888;font-size:0.85rem;margin-bottom:12px;">Select specific sections to study, or leave all unchecked for the full pool.</p>
<div class="section-groups" id="sectionGroups"></div>
<div class="section-actions">
<button class="section-action-btn" onclick="selectAllSections()">Select All</button>
<button class="section-action-btn" onclick="clearAllSections()">Clear All</button>
</div>
</div>
</div>
<div id="quiz">
<div class="progress-bar"><div class="progress-fill" id="progressFill"></div></div>
<div class="question-info"><span id="questionCounter"></span><span id="scoreTracker"></span></div>
<div class="question-card">
<div class="question-id" id="questionId"></div>
<div class="question-figure" id="questionFigure"></div>
<div class="question-text" id="questionText"></div>
<div class="answers" id="answersContainer"></div>
<div class="feedback" id="feedback"></div>
</div>
<button class="next-btn" id="nextBtn" onclick="nextQuestion()">Next Question</button>
</div>
<div id="results">
<div class="results-card">
<div class="score-circle" id="scoreCircle"></div>
<div class="results-text" id="resultsText"></div>
<div class="results-detail" id="resultsDetail"></div>
<div class="results-actions">
<button class="btn-primary" onclick="startQuiz(totalQuestions)">Try Again</button>
<button class="btn-secondary" onclick="showSetup()">Change Settings</button>
</div>
<div class="review-section" id="reviewSection"></div>
</div>
</div>
</div>
<script>
var figures = {
HTMLPART1

# Insert the base64 figure data
echo "\"E5-1\":\"data:image/png;base64,${E51}\"," >> "$DIR/index.html"
echo "\"E6-1\":\"data:image/png;base64,${E61}\"," >> "$DIR/index.html"
echo "\"E6-2\":\"data:image/png;base64,${E62}\"," >> "$DIR/index.html"
echo "\"E6-3\":\"data:image/png;base64,${E63}\"," >> "$DIR/index.html"
echo "\"E7-1\":\"data:image/png;base64,${E71}\"," >> "$DIR/index.html"
echo "\"E7-2\":\"data:image/png;base64,${E72}\"," >> "$DIR/index.html"
echo "\"E7-3\":\"data:image/png;base64,${E73}\"," >> "$DIR/index.html"
echo "\"E9-1\":\"data:image/png;base64,${E91}\"," >> "$DIR/index.html"
echo "\"E9-2\":\"data:image/png;base64,${E92}\"," >> "$DIR/index.html"
echo "\"E9-3\":\"data:image/png;base64,${E93}\"" >> "$DIR/index.html"

cat >> "$DIR/index.html" << 'HTMLPART2'
};
var allQuestions =
HTMLPART2

# Append the JSON data
cat "$DIR/questions.json" >> "$DIR/index.html"

cat >> "$DIR/index.html" << 'HTMLPART3'
;
var sectionNames={
"E1A":"Frequency privileges; stations aboard ships/aircraft",
"E1B":"Station restrictions; spurious emissions; RACES",
"E1C":"Automatic/remote control; band-specific regulations",
"E1D":"Space and Earth stations; telemetry; telecommand",
"E1E":"Volunteer examiner program",
"E1F":"RF power amplifiers; prohibited communications; spread spectrum",
"E2A":"Amateur radio in space; satellites",
"E2B":"Television practices: fast-scan and slow-scan",
"E2C":"Contest/DX operating; remote operation; mesh networks",
"E2D":"Digital modes for VHF/UHF; APRS; EME; meteor scatter",
"E2E":"Digital modes and procedures for HF",
"E3A":"EME; meteor scatter; tropospheric propagation; auroral",
"E3B":"Transequatorial; long-path; chordal hop; sporadic-E",
"E3C":"Propagation prediction; radio horizon; space weather",
"E4A":"Test equipment; spectrum analyzers; oscilloscopes",
"E4B":"Measurement techniques; S parameters; VNA",
"E4C":"Receiver performance: noise, MDS, dynamic range",
"E4D":"Dynamic range; intermodulation; third-order intercept",
"E4E":"Noise and interference; DSP filtering; grounding",
"E5A":"Resonance and Q; series and parallel resonance",
"E5B":"Time constants; phase relationships; admittance",
"E5C":"Coordinate systems; phasors; polar/rectangular",
"E5D":"Skin effect; real and reactive power; electrical length",
"E6A":"Semiconductor materials; BJTs; FETs",
"E6B":"Diodes",
"E6C":"Digital ICs; gates; programmable logic",
"E6D":"Inductors; piezoelectricity; transformers",
"E6E":"Semiconductor packages for RF use; MMICs",
"E6F":"Electro-optical technology; photovoltaic devices",
"E7A":"Digital circuits; logic; frequency dividers",
"E7B":"Amplifiers: class of operation; distortion",
"E7C":"Filters and matching networks",
"E7D":"Power supplies and voltage regulators",
"E7E":"Modulation and demodulation; mixers",
"E7F":"Software defined radio; DSP; digital filters",
"E7G":"Operational amplifiers",
"E7H":"Oscillators; synthesizers; PLLs; DDS",
"E8A":"Fourier analysis; RMS; PEP; A/D conversion",
"E8B":"Modulation index; deviation ratio; multiplexing; OFDM",
"E8C":"Digital signals; error correction; constellation diagrams",
"E8D":"Keying defects; digital codes; spread spectrum",
"E9A":"Antenna parameters: gain, efficiency, ERP, EIRP",
"E9B":"Antenna patterns; gain; antenna modeling",
"E9C":"Wire antennas; folded dipoles; phased arrays",
"E9D":"Yagi antennas; parabolic reflectors; loading",
"E9E":"Impedance matching; phasing lines; power dividers",
"E9F":"Transmission lines; velocity factor; microstrip",
"E9G":"The Smith chart",
"E9H":"Receiving antennas; RDF; Beverage; loops",
"E0A":"RF safety; hazardous materials; grounding"
};
var quizQuestions=[], currentIndex=0, correctCount=0, totalQuestions=50, answered=false, missed=[];
var activeSections=new Set();
function getSections(){var s={};allQuestions.forEach(function(q){var sec=q.id.replace(/\d+$/,'');if(!s[sec])s[sec]=0;s[sec]++;});return s;}
function buildSectionChips(){var s=getSections();var el=document.getElementById('sectionGroups');el.innerHTML='';Object.keys(s).sort().forEach(function(sec){var chip=document.createElement('label');chip.className='section-chip';chip.innerHTML='<input type="checkbox" value="'+sec+'">'+sec+' <span class="chip-count">('+s[sec]+')</span>';chip.onclick=function(){var cb=this.querySelector('input');cb.checked=!cb.checked;if(cb.checked){activeSections.add(sec);this.classList.add('active');}else{activeSections.delete(sec);this.classList.remove('active');}};el.appendChild(chip);});}
function selectAllSections(){document.querySelectorAll('.section-chip').forEach(function(c){c.classList.add('active');c.querySelector('input').checked=true;activeSections.add(c.querySelector('input').value);});}
function clearAllSections(){document.querySelectorAll('.section-chip').forEach(function(c){c.classList.remove('active');c.querySelector('input').checked=false;});activeSections.clear();}
function getFilteredQuestions(){if(activeSections.size===0)return allQuestions.slice();return allQuestions.filter(function(q){var sec=q.id.replace(/\d+$/,'');return activeSections.has(sec);});}
function shuffle(a){for(var i=a.length-1;i>0;i--){var j=Math.floor(Math.random()*(i+1));var t=a[i];a[i]=a[j];a[j]=t;}return a;}
function startQuiz(count){var pool=getFilteredQuestions();count=Math.max(1,Math.min(count||50,pool.length));totalQuestions=count;quizQuestions=shuffle(pool).slice(0,count);currentIndex=0;correctCount=0;answered=false;missed=[];document.getElementById('setup').style.display='none';document.getElementById('results').style.display='none';document.getElementById('quiz').style.display='block';showQuestion();}
var answerMap=[];
function showQuestion(){var q=quizQuestions[currentIndex];answered=false;document.getElementById('questionId').textContent=q.id+(q.refs?' '+q.refs:'');document.getElementById('questionText').textContent=q.question;document.getElementById('questionCounter').textContent='Question '+(currentIndex+1)+' of '+totalQuestions;document.getElementById('scoreTracker').textContent='Score: '+correctCount+'/'+currentIndex;document.getElementById('progressFill').style.width=((currentIndex/totalQuestions)*100)+'%';document.getElementById('feedback').className='feedback';document.getElementById('feedback').textContent='';document.getElementById('nextBtn').style.display='none';var fig=document.getElementById('questionFigure');if(q.figure&&figures[q.figure]){fig.innerHTML='<img src="'+figures[q.figure]+'" alt="'+q.figure+'">';fig.style.display='block';}else{fig.innerHTML='';fig.style.display='none';}var c=document.getElementById('answersContainer');c.innerHTML='';var L=['A','B','C','D'];answerMap=[0,1,2,3];for(var i=answerMap.length-1;i>0;i--){var j=Math.floor(Math.random()*(i+1));var t=answerMap[i];answerMap[i]=answerMap[j];answerMap[j]=t;}for(var i=0;i<answerMap.length;i++){var b=document.createElement('button');b.className='answer-btn';b.innerHTML='<span class="answer-letter">'+L[i]+'</span>'+q.answers[answerMap[i]];b.setAttribute('data-i',String(answerMap[i]));b.onclick=function(){selectAnswer(parseInt(this.getAttribute('data-i')));};c.appendChild(b);}}
function selectAnswer(s){if(answered)return;answered=true;var q=quizQuestions[currentIndex];var btns=document.querySelectorAll('.answer-btn');var fb=document.getElementById('feedback');var L=['A','B','C','D'];for(var i=0;i<btns.length;i++){var origIdx=parseInt(btns[i].getAttribute('data-i'));btns[i].classList.add('disabled');if(origIdx===q.correct)btns[i].classList.add('correct');if(origIdx===s&&s!==q.correct)btns[i].classList.add('incorrect');}if(s===q.correct){correctCount++;fb.className='feedback correct-fb';fb.innerHTML='Correct!';}else{var correctShuffledPos=answerMap.indexOf(q.correct);fb.className='feedback incorrect-fb';fb.innerHTML='Incorrect. The correct answer is <strong>'+L[correctShuffledPos]+': '+q.answers[q.correct]+'</strong>';missed.push({question:q,selected:s,answerMap:answerMap.slice()});}if(q.refs){fb.innerHTML+='<div class="ref-text">Reference: '+q.refs+'</div>';}document.getElementById('scoreTracker').textContent='Score: '+correctCount+'/'+(currentIndex+1);document.getElementById('nextBtn').style.display='block';document.getElementById('nextBtn').textContent=currentIndex<totalQuestions-1?'Next Question':'See Results';}
function nextQuestion(){currentIndex++;if(currentIndex>=totalQuestions){showResults();}else{showQuestion();}}
function showResults(){document.getElementById('quiz').style.display='none';document.getElementById('results').style.display='block';var pct=Math.round((correctCount/totalQuestions)*100);var passed=pct>=74;var c=document.getElementById('scoreCircle');c.className='score-circle '+(passed?'pass':'fail');c.textContent=pct+'%';document.getElementById('resultsText').textContent=passed?'You Passed!':'Keep Studying';document.getElementById('resultsDetail').textContent=correctCount+' correct out of '+totalQuestions+' (passing is 74%)';var r=document.getElementById('reviewSection');if(missed.length>0){var L=['A','B','C','D'];var h='<h3>Missed Questions ('+missed.length+')</h3>';for(var i=0;i<missed.length;i++){var m=missed[i];var yourPos=m.answerMap.indexOf(m.selected);var correctPos=m.answerMap.indexOf(m.question.correct);h+='<div class="review-item"><div class="q-id">'+m.question.id+'</div><div class="q-text">'+m.question.question+'</div><div class="your-answer">Your answer: '+L[yourPos]+' - '+m.question.answers[m.selected]+'</div><div class="correct-answer">Correct: '+L[correctPos]+' - '+m.question.answers[m.question.correct]+'</div></div>';}r.innerHTML=h;}else{r.innerHTML='<h3 style="color:#4caf50;">Perfect Score!</h3>';}}
function showSetup(){document.getElementById('quiz').style.display='none';document.getElementById('results').style.display='none';document.getElementById('setup').style.display='block';}
buildSectionChips();
</script>
</body>
</html>
HTMLPART3

echo "Built: $(wc -c < "$DIR/index.html") bytes"
