import os
import sys
from PIL import Image, ImageOps

TARGET_SIZES = {
    '6.9_inch': (1320, 2868),
    '6.7_inch': (1290, 2796),
    '6.5_inch': (1242, 2688),
    '6.3_inch': (1206, 2622),
    '6.1_inch': (1179, 2556),
    'ipad_13_inch': (2064, 2752),
    'ipad_12_9_inch': (2048, 2732),
}

def pick_best_source(src_root, is_ipad):
    candidates = ['sim_ipad', 'sim_6.9', 'sim_6.3'] if is_ipad else ['sim_6.9', 'sim_6.3', 'sim_ipad']
    for c in candidates:
        p = os.path.join(src_root, c)
        if os.path.isdir(p) and any(f.endswith('.png') for f in os.listdir(p)):
            return p
    return None

def main():
    src_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'screenshots'))
    for target_name, (w, h) in TARGET_SIZES.items():
        is_ipad = target_name.startswith('ipad_')
        exact_dir = os.path.join(src_root, f'sim_{target_name}')
        src_dir = exact_dir if os.path.isdir(exact_dir) else pick_best_source(src_root, is_ipad)
        if not src_dir:
            print(f'Skipping {target_name}: no simulator source found')
            continue

        out_dir = os.path.join(src_root, target_name)
        os.makedirs(out_dir, exist_ok=True)
        for f in sorted(os.listdir(src_dir)):
            if not f.endswith('.png'):
                continue
            im = Image.open(os.path.join(src_dir, f)).convert('RGB')
            if im.size != (w, h):
                im = ImageOps.fit(im, (w, h), method=Image.Resampling.LANCZOS)
            out_path = os.path.join(out_dir, f)
            im.save(out_path, format='PNG', optimize=True)
            print(f'Normalized {out_path} -> {w}x{h}')

if __name__ == '__main__':
    main()

