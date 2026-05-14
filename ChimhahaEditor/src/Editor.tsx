import { CKEditor } from '@ckeditor/ckeditor5-react';
import {
    ClassicEditor,
    Bold, Italic, Underline, Strikethrough,
    FontFamily, FontSize, FontColor, FontBackgroundColor,
    Alignment,
    List, Indent,
    BlockQuote, HorizontalLine,
    Link,
    Image, ImageUpload, ImageToolbar, ImageCaption, ImageStyle,
    MediaEmbed,
    Table, TableToolbar,
    FindAndReplace,
    Undo,
    SourceEditing,
    Essentials,
 } from 'ckeditor5';
import 'ckeditor5/ckeditor5.css';

interface EditorProps {
    onChange: (data: string) => void;
}

export default function Editor({ onChange }: EditorProps) {
    return (
        <CKEditor
        editor={ClassicEditor}
        config={{
            licenseKey: 'GPL',
            plugins: [
                Essentials,
                Bold, Italic, Underline, Strikethrough,
                FontFamily, FontSize, FontColor, FontBackgroundColor,
                Alignment,
                List, Indent,
                BlockQuote, HorizontalLine,
                Link,
                Image, ImageUpload, ImageToolbar, ImageCaption, ImageStyle,
                MediaEmbed,
                Table, TableToolbar,
                FindAndReplace,
                Undo,
                SourceEditing,
            ],
            toolbar: {
                items: [
                    'undo', 'redo', '|',
                    'sourceEditing', 'findAndReplace', '|',
                    'bold', 'italic', 'underline', 'strikethrough', '|',
                    'fontFamily', 'fontSize', 'fontColor', 'fontBackgroundColor', '|',
                    'alignment', '|',
                    'bulletedList', 'numberedList', 'indent', 'outdent', '|',
                    'blockQuote', 'horizontalLine', '|',
                    'link', 'insertImage', 'mediaEmbed', 'insertTable',
                ]
            },
            fontFamily: {
                options: [
                    'default',
                    '나눔고딕, sans-serif',
                    '나눔명조, serif',
                    '메이플스토리, sans-serif',
                    'Arial, sans-serif',
                    'Georgia, serif',
                ],
                supportAllValues: true,
            },
        }}
        onChange={(_, editor) => onChange(editor.getData())}
        />
    );
}