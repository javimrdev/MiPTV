import React, { useState } from 'react';
import {
  Modal,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { useTheme } from '../theme/useTheme';

type PinEntryModalProps = {
  visible: boolean;
  onClose: () => void;
  onSave: (pin: string) => void;
  title: string;
};

export function PinEntryModal({ visible, onClose, onSave, title }: PinEntryModalProps) {
  const { t } = useTranslation();
  const theme = useTheme();
  const [pin, setPin] = useState('');
  const [confirm, setConfirm] = useState('');

  const handleSave = () => {
    if (pin.length < 4) {
      Alert.alert(t('settings.pinEntry'), 'PIN must be at least 4 digits');
      return;
    }
    if (pin !== confirm) {
      Alert.alert(t('settings.pinEntry'), t('settings.pinMismatch'));
      return;
    }
    onSave(pin);
    setPin('');
    setConfirm('');
  };

  const handleClose = () => {
    setPin('');
    setConfirm('');
    onClose();
  };

  const inputStyle = [styles.input, { borderColor: theme.colors.border, color: theme.colors.text, backgroundColor: theme.colors.surface }];

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={handleClose}>
      <View style={styles.backdrop}>
        <View style={[styles.card, { backgroundColor: theme.colors.surface, borderColor: theme.colors.border }]}>
          <Text style={[styles.title, { color: theme.colors.text }]}>{title}</Text>

          <Text style={[styles.label, { color: theme.colors.textSecondary }]}>{t('settings.pinEntry')}</Text>
          <TextInput
            style={inputStyle}
            value={pin}
            onChangeText={setPin}
            keyboardType="numeric"
            secureTextEntry
            maxLength={8}
            placeholderTextColor={theme.colors.textDisabled}
            placeholder="••••"
          />

          <Text style={[styles.label, { color: theme.colors.textSecondary }]}>{t('settings.pinConfirm')}</Text>
          <TextInput
            style={inputStyle}
            value={confirm}
            onChangeText={setConfirm}
            keyboardType="numeric"
            secureTextEntry
            maxLength={8}
            placeholderTextColor={theme.colors.textDisabled}
            placeholder="••••"
          />

          <View style={styles.buttons}>
            <TouchableOpacity style={[styles.btn, { borderColor: theme.colors.border }]} onPress={handleClose}>
              <Text style={[styles.btnText, { color: theme.colors.textSecondary }]}>{t('settings.pinCancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.btn, styles.btnPrimary, { backgroundColor: theme.colors.primary }]} onPress={handleSave}>
              <Text style={[styles.btnText, styles.btnPrimaryText]}>{t('settings.pinSave')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  card: {
    width: '100%',
    maxWidth: 360,
    borderRadius: 16,
    borderWidth: 1,
    padding: 24,
  },
  title: { fontSize: 18, fontWeight: '600', marginBottom: 20 },
  label: { fontSize: 13, fontWeight: '500', marginBottom: 6, marginTop: 12 },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 16,
    letterSpacing: 4,
  },
  buttons: { flexDirection: 'row', gap: 12, marginTop: 24 },
  btn: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: 8,
    borderWidth: 1,
    alignItems: 'center',
  },
  btnPrimary: { borderWidth: 0 },
  btnText: { fontSize: 15, fontWeight: '500' },
  btnPrimaryText: { color: '#fff' },
});
