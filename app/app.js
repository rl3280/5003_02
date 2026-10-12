const frames = [
  { id: "0249", time: "02:49", activity: "Apprentice Hammering", phase: "DownSwing", condition: "", role: "Journeyman" },
  { id: "0250", time: "02:50", activity: "Apprentice Hammering", phase: "BackSwing", condition: "", role: "Journeyman" },
  { id: "0251", time: "02:51", activity: "Journeyman Inspects Nail", phase: "", condition: "InspectNail", role: "Journeyman" },
  { id: "0254", time: "02:54", activity: "Apprentice Pulling Out Nail", phase: "RemoveNail", condition: "", role: "Journeyman" },
  { id: "0307", time: "03:07", activity: "Journeyman Flush Align Panel Edges", phase: "", condition: "AlignBoardsFlush", role: "Journeyman" },
  { id: "0313", time: "03:13", activity: "Apprentice Hammering", phase: "", condition: "AlignHammer", role: "Journeyman" },
  { id: "0315", time: "03:15", activity: "Apprentice Hammering", phase: "DownSwing", condition: "", role: "Journeyman" },
  { id: "0316", time: "03:16", activity: "Apprentice Hammering", phase: "BackSwing", condition: "", role: "Journeyman" },
  { id: "0319", time: "03:19", activity: "Apprentice Hammering", phase: "", condition: "InspectNail", role: "Journeyman" },
  { id: "0324", time: "03:24", activity: "Apprentice Hammering", phase: "", condition: "AlignNail", role: "Journeyman" },
  { id: "0327", time: "03:27", activity: "Journeyman Inspects Nail", phase: "", condition: "InspectNail", role: "Journeyman" },
  { id: "0332", time: "03:32", activity: "Journeyman Realigns Nail", phase: "", condition: "AlignNail", role: "Journeyman" },
  { id: "0337", time: "03:37", activity: "Journeyman Flush Align Panel Edges", phase: "", condition: "AlignBoardsFlush", role: "Journeyman" },
  { id: "0341", time: "03:41", activity: "Apprentice Hammering", phase: "BackSwing", condition: "", role: "Journeyman" },
  { id: "0343", time: "03:43", activity: "Apprentice Hammering", phase: "DownSwing", condition: "", role: "Journeyman" },
  { id: "0349", time: "03:49", activity: "Apprentice Hammering", phase: "DownSwing", condition: "", role: "Journeyman" },
  { id: "0350", time: "03:50", activity: "Apprentice Hammering", phase: "", condition: "InspectNail", role: "Journeyman" },
  { id: "0352", time: "03:52", activity: "Apprentice Hammering", phase: "BackSwing", condition: "", role: "Journeyman" },
  { id: "0353", time: "03:53", activity: "Apprentice Hammering", phase: "DownSwing", condition: "", role: "Journeyman" },
  { id: "0401", time: "04:01", activity: "Apprentice Hammering", phase: "", condition: "AlignHammer", role: "Journeyman" },
  { id: "0408", time: "04:08", activity: "Apprentice Hammering", phase: "DownSwing", condition: "", role: "Journeyman" },
  { id: "0410", time: "04:10", activity: "Apprentice Hammering", phase: "BackSwing", condition: "", role: "Journeyman" },
  { id: "0415", time: "04:15", activity: "Apprentice Hammering", phase: "", condition: "", role: "Journeyman" }
];

const elements = {
  image: document.querySelector("#frame-image"),
  imageId: document.querySelector("#image-id"),
  time: document.querySelector("#frame-time"),
  activity: document.querySelector("#activity-label"),
  context: document.querySelector("#annotation-context"),
  phase: document.querySelector("#phase-value"),
  condition: document.querySelector("#condition-value"),
  role: document.querySelector("#role-value"),
  annotationIndex: document.querySelector("#annotation-index"),
  frameCount: document.querySelector("#frame-count"),
  timeline: document.querySelector("#timeline"),
  filter: document.querySelector("#activity-filter"),
  previous: document.querySelector("#previous-frame"),
  next: document.querySelector("#next-frame"),
  play: document.querySelector("#play-frames"),
  playLabel: document.querySelector("#play-label")
};

let visibleFrames = [...frames.keys()];
let currentFrame = 0;
let playbackTimer;

function describeFrame(frame) {
  const details = [];
  if (frame.phase) details.push(`Process phase: ${frame.phase}.`);
  if (frame.condition) details.push(`Condition code: ${frame.condition}.`);
  if (details.length === 0) details.push("No process-phase or condition code is recorded for this frame.");
  return details.join(" ");
}

function setField(element, value) {
  element.textContent = value || "Not coded";
  element.classList.toggle("is-empty", !value);
}

function renderTimeline() {
  elements.timeline.replaceChildren();

  visibleFrames.forEach((frameIndex, visibleIndex) => {
    const frame = frames[frameIndex];
    const button = document.createElement("button");
    button.type = "button";
    button.className = "timeline-button";
    button.dataset.frameIndex = String(frameIndex);
    button.dataset.kind = frame.activity.startsWith("Apprentice") ? "apprentice" : "journeyman";
    button.setAttribute("aria-label", `${frame.time}, ${frame.activity}`);
    button.innerHTML = `<span class="timeline-dot" aria-hidden="true"></span><span class="timeline-time">${frame.time}</span>`;
    button.addEventListener("click", () => {
      currentFrame = visibleIndex;
      renderFrame();
    });
    elements.timeline.append(button);
  });
}

function renderFrame() {
  const frame = frames[visibleFrames[currentFrame]];
  if (!frame) return;

  elements.image.src = `../clips/${frame.id}.jpg`;
  elements.image.alt = `Source video frame ${frame.id}.jpg, timestamp ${frame.time}.`;
  elements.imageId.textContent = `${frame.id}.jpg`;
  elements.time.textContent = frame.time;
  elements.activity.textContent = frame.activity;
  elements.context.textContent = describeFrame(frame);
  setField(elements.phase, frame.phase);
  setField(elements.condition, frame.condition);
  setField(elements.role, frame.role);
  elements.annotationIndex.textContent = `${String(currentFrame + 1).padStart(2, "0")} / ${String(visibleFrames.length).padStart(2, "0")}`;
  elements.frameCount.innerHTML = `${String(currentFrame + 1).padStart(2, "0")} <span>/</span> ${String(visibleFrames.length).padStart(2, "0")}`;
  elements.previous.disabled = currentFrame === 0;
  elements.next.disabled = currentFrame === visibleFrames.length - 1;

  for (const button of elements.timeline.querySelectorAll(".timeline-button")) {
    if (Number(button.dataset.frameIndex) === visibleFrames[currentFrame]) {
      button.setAttribute("aria-current", "step");
    } else {
      button.removeAttribute("aria-current");
    }
  }
}

function stopPlayback() {
  window.clearInterval(playbackTimer);
  playbackTimer = undefined;
  elements.play.classList.remove("is-playing");
  elements.play.setAttribute("aria-label", "Play frame sequence");
  elements.playLabel.textContent = "PLAY THE MOMENTS";
}

function moveFrame(amount) {
  const next = currentFrame + amount;
  if (next < 0 || next >= visibleFrames.length) {
    stopPlayback();
    return;
  }
  currentFrame = next;
  renderFrame();
}

elements.filter.addEventListener("change", () => {
  stopPlayback();
  const filter = elements.filter.value;
  visibleFrames = frames.reduce((indices, frame, index) => {
    const isApprenticeActivity = frame.activity.startsWith("Apprentice");
    if (filter === "all" || (filter === "apprentice" && isApprenticeActivity) || (filter === "journeyman" && !isApprenticeActivity)) {
      indices.push(index);
    }
    return indices;
  }, []);
  currentFrame = 0;
  renderTimeline();
  renderFrame();
});

elements.previous.addEventListener("click", () => moveFrame(-1));
elements.next.addEventListener("click", () => moveFrame(1));
elements.play.addEventListener("click", () => {
  if (playbackTimer) {
    stopPlayback();
    return;
  }
  if (currentFrame === visibleFrames.length - 1) currentFrame = -1;
  elements.play.classList.add("is-playing");
  elements.play.setAttribute("aria-label", "Pause frame sequence");
  elements.playLabel.textContent = "PAUSE";
  playbackTimer = window.setInterval(() => moveFrame(1), 1450);
});

renderTimeline();
renderFrame();
